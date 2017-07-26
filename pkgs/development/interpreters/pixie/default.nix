{ stdenv, fetchgit, fetchurl, python2, makeWrapper, pkgconfig, gcc,
  pypy, libffi, libedit, libuv, boost, zlib,
  variant ? "jit", buildWithPypy ? false }:

let
  commit-count = "1356";
  common-flags = "--thread --gcrootfinder=shadowstack --continuation";
  variants = {
    jit = { flags = "--opt=jit"; target = "target.py"; };
    jit-preload = { flags = "--opt=jit"; target = "target_preload.py"; };
    no-jit = { flags = ""; target = "target.py"; };
    no-jit-preload = { flags = ""; target = "target_preload.py"; };
  };
  pixie-src = fetchgit {
    url = "https://github.com/pixie-lang/pixie.git";
    rev = "d2a4267ea088f711af36a74928e8dfd8360584ad";
    sha256 = "1asf6yx7zy9cx4bsg8iai57dy3r3m45xcmkmw2vix70xvfy23ryf";
  };
  pypy-tag = "91db1a9";
  pypy-src = fetchurl {
    name = "pypy-src-${pypy-tag}";
    url = "https://bitbucket.org/pypy/pypy/get/${pypy-tag}.tar.bz2";
    sha256 = "0ylbqvhbcp5m09l15i2q2h3a0vjd055x2r37cq71lkhgmmaxrwbq";
  };
  libs = [ libffi libedit libuv boost.dev boost.out zlib ];
  include-path = stdenv.lib.concatStringsSep ":"
                   (map (p: "${p}/include") libs);
  library-path = stdenv.lib.concatStringsSep ":"
                   (map (p: "${p}/lib") libs);
  bin-path = stdenv.lib.concatStringsSep ":"
               (map (p: "${p}/bin") [ gcc ]);
  build = {flags, target}: stdenv.mkDerivation rec {
    name = "pixie-${version}";
    version = "0-r${commit-count}-${variant}";
    nativeBuildInputs = libs;
    buildInputs = [ pkgconfig makeWrapper ];
    PYTHON = if buildWithPypy
      then "${pypy}/pypy-c/.pypy-c-wrapped"
      else "${python2.interpreter}";
    unpackPhase = ''
      cp -R ${pixie-src} pixie-src
      mkdir pypy-src
      (cd pypy-src
       tar --strip-components=1 -xjf ${pypy-src})
      chmod -R +w pypy-src pixie-src
    '';
    patchPhase = ''
      (cd pixie-src
       patch -p1 < ${./load_paths.patch}
       libraryPaths='["${libuv}" "${libedit}" "${libffi.dev}" "${boost.dev}" "${boost.out}" "${zlib.dev}"]'
       export libraryPaths
       substituteAllInPlace ./pixie/ffi-infer.pxi)
    '';
    buildPhase = ''(
      PYTHONPATH="`pwd`/pypy-src:$PYTHONPATH";
      RPYTHON="`pwd`/pypy-src/rpython/bin/rpython";
      cd pixie-src
      $PYTHON $RPYTHON ${common-flags} ${target}
      export LD_LIBRARY_PATH="${library-path}:$LD_LIBRARY_PATH"
      find pixie -name "*.pxi" -exec ./pixie-vm -c {} \;
    )'';
    installPhase = ''
      mkdir -p $out/share $out/bin
      cp pixie-src/pixie-vm $out/share/pixie-vm
      cp -R pixie-src/pixie $out/share/pixie
      makeWrapper $out/share/pixie-vm $out/bin/pixie-vm \
        --prefix LD_LIBRARY_PATH : ${library-path} \
        --prefix C_INCLUDE_PATH : ${include-path} \
        --prefix LIBRARY_PATH : ${library-path} \
        --prefix PATH : ${bin-path}
      cat > $out/bin/pxi <<EOF
      #!$shell
      >&2 echo "[\$\$] WARNING: 'pxi' is a deprecated alias for 'pixie-vm', please update your scripts."
      exec $out/bin/pixie-vm "\$@"
      EOF
      chmod +x $out/bin/pxi
    '';
    meta = {
      description = "A clojure-like lisp, built with the pypy vm toolkit";
      homepage = "https://github.com/pixie-lang/pixie";
      license = stdenv.lib.licenses.lgpl3;
      platforms = ["x86_64-linux" "i686-linux"];
    };
  };
in build (builtins.getAttr variant variants)
