{ stdenv, fetchurl, fetchpatch, buildPackages
, bzip2
, expat
, libffi
, gdbm
, lzma
, ncurses
, openssl
, readline
, sqlite
, tcl ? null, tk ? null, tix ? null, libX11 ? null, xproto ? null, x11Support ? false
, zlib
, callPackage
, self
, CF, configd
, python-setup-hook
# For the Python package set
, packageOverrides ? (self: super: {})
}:

assert x11Support -> tcl != null
                  && tk != null
                  && xproto != null
                  && libX11 != null;
with stdenv.lib;

let
  majorVersion = "3.6";
  minorVersion = "6";
  minorVersionSuffix = "";
  version = "${majorVersion}.${minorVersion}${minorVersionSuffix}";
  libPrefix = "python${majorVersion}";
  sitePackages = "lib/${libPrefix}/site-packages";

  buildInputs = filter (p: p != null) [
    zlib bzip2 expat lzma libffi gdbm sqlite readline ncurses openssl ]
    ++ optionals x11Support [ tcl tk libX11 xproto ]
    ++ optionals stdenv.isDarwin [ CF configd ];

  nativeBuildInputs =
    optional (stdenv.hostPlatform != stdenv.buildPlatform) buildPackages.python3;

  hasDistutilsCxxPatch = !(stdenv.cc.isGNU or false);

in stdenv.mkDerivation {
  name = "python3-${version}";
  pythonVersion = majorVersion;
  inherit majorVersion version;

  inherit buildInputs nativeBuildInputs;

  src = fetchurl {
    url = "https://www.python.org/ftp/python/${majorVersion}.${minorVersion}/Python-${version}.tar.xz";
    sha256 = "0vz1wqg50zq6g15givdx1s2rq5752y5g2f1978bs6wvf8mfw36yp";
  };

  NIX_LDFLAGS = optionalString stdenv.isLinux "-lgcc_s";

  # Determinism: The interpreter is patched to write null timestamps when compiling python files.
  # This way python doesn't try to update them when we freeze timestamps in nix store.
  DETERMINISTIC_BUILD=1;
  # Determinism: We fix the hashes of str, bytes and datetime objects.
  PYTHONHASHSEED=0;

  prePatch = optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace '`/usr/bin/arch`' '"i386"'
    substituteInPlace configure --replace '-Wl,-stack_size,1000000' ' '
  '';

  patches = [
    ./no-ldconfig.patch
  ] ++ optionals stdenv.isDarwin [
    # Fix for https://bugs.python.org/issue24658
    (fetchpatch {
      url = "https://bugs.python.org/file45178/issue24658-3-3.6.diff";
      sha256 = "1x060hs80nl34mcl2ji2i7l4shxkmxwgq8h8lcmav8rjqqz1nb4a";
    })
  ] ++ optionals (x11Support && stdenv.isDarwin) [
    ./use-correct-tcl-tk-on-darwin.patch
  ] ++ optionals hasDistutilsCxxPatch [
    # Fix for http://bugs.python.org/issue1222585
    # Upstream distutils is calling C compiler to compile C++ code, which
    # only works for GCC and Apple Clang. This makes distutils to call C++
    # compiler when needed.
    (fetchpatch {
      url = "https://bugs.python.org/file47669/python-3.8-distutils-C++.patch";
      sha256 = "0s801d7ww9yrk6ys053jvdhl0wicbznx08idy36f1nrrxsghb3ii";
    })
  ];

  postPatch = ''
    # Determinism
    substituteInPlace "Lib/py_compile.py" --replace "source_stats['mtime']" "(1 if 'DETERMINISTIC_BUILD' in os.environ else source_stats['mtime'])"
    # Determinism. This is done unconditionally
    substituteInPlace "Lib/importlib/_bootstrap_external.py" --replace "source_mtime = int(st['mtime'])" "source_mtime = 1"
  '' + optionalString (x11Support && (tix != null)) ''
    substituteInPlace "Lib/tkinter/tix.py" --replace "os.environ.get('TIX_LIBRARY')" "os.environ.get('TIX_LIBRARY') or '${tix}/lib'"
  '';

  CPPFLAGS="${concatStringsSep " " (map (p: "-I${getDev p}/include") buildInputs)}";
  LDFLAGS="${concatStringsSep " " (map (p: "-L${getLib p}/lib") buildInputs)}";
  LIBS="${optionalString (!stdenv.isDarwin) "-lcrypt"} ${optionalString (ncurses != null) "-lncurses"}";

  configureFlags = [
    "--enable-shared"
    "--with-threads"
    "--without-ensurepip"
    "--with-system-expat"
    "--with-system-ffi"
  ] ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_buggy_getaddrinfo=no"
    # Assume little-endian IEEE 754 floating point when cross compiling
    "ac_cv_little_endian_double=yes"
    "ac_cv_big_endian_double=no"
    "ac_cv_mixed_endian_double=no"
    "ac_cv_x87_double_rounding=yes"
    "ac_cv_tanh_preserves_zero_sign=yes"
    # Generally assume that things are present and work
    "ac_cv_posix_semaphores_enabled=yes"
    "ac_cv_broken_sem_getvalue=no"
    "ac_cv_wchar_t_signed=yes"
    "ac_cv_rshift_extends_sign=yes"
    "ac_cv_broken_nice=no"
    "ac_cv_broken_poll=no"
    "ac_cv_working_tzset=yes"
    "ac_cv_have_long_long_format=yes"
    "ac_cv_have_size_t_format=yes"
    "ac_cv_computed_gotos=yes"
    "ac_cv_file__dev_ptmx=yes"
    "ac_cv_file__dev_ptc=yes"
  ]
    # Never even try to use lchmod on linux,
    # don't rely on detecting glibc-isms.
  ++ optional stdenv.hostPlatform.isLinux "ac_cv_func_lchmod=no";

  preConfigure = ''
    for i in /usr /sw /opt /pkg; do	# improve purity
      substituteInPlace ./setup.py --replace $i /no-such-path
    done
    ${optionalString stdenv.isDarwin ''
       export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -msse2"
       export MACOSX_DEPLOYMENT_TARGET=10.6
     ''
     + optionalString stdenv.hostPlatform.isMusl ''
      export NIX_CFLAGS_COMPILE+=" -DTHREAD_STACK_SIZE=0x100000"
     ''}
  '';

  setupHook = python-setup-hook sitePackages;

  postInstall = ''
    # needed for some packages, especially packages that backport functionality
    # to 2.x from 3.x
    for item in $out/lib/python${majorVersion}/test/*; do
      if [[ "$item" != */test_support.py*
         && "$item" != */test/support
         && "$item" != */test/libregrtest
         && "$item" != */test/regrtest.py* ]]; then
        rm -rf "$item"
      else
        echo $item
      fi
    done
    touch $out/lib/python${majorVersion}/test/__init__.py

    ln -s "$out/include/python${majorVersion}m" "$out/include/python${majorVersion}"
    paxmark E $out/bin/python${majorVersion}

    # Python on Nix is not manylinux1 compatible. https://github.com/NixOS/nixpkgs/issues/18484
    echo "manylinux1_compatible=False" >> $out/lib/${libPrefix}/_manylinux.py

    # Determinism: Windows installers were not deterministic.
    # We're also not interested in building Windows installers.
    find "$out" -name 'wininst*.exe' | xargs -r rm -f

    # Use Python3 as default python
    ln -s "$out/bin/idle3" "$out/bin/idle"
    ln -s "$out/bin/pydoc3" "$out/bin/pydoc"
    ln -s "$out/bin/python3" "$out/bin/python"
    ln -s "$out/bin/python3-config" "$out/bin/python-config"
    ln -s "$out/lib/pkgconfig/python3.pc" "$out/lib/pkgconfig/python.pc"

    # Get rid of retained dependencies on -dev packages, and remove
    # some $TMPDIR references to improve binary reproducibility.
    # Note that the .pyc file of _sysconfigdata.py should be regenerated!
    for i in $out/lib/python${majorVersion}/_sysconfigdata*.py $out/lib/python${majorVersion}/config-${majorVersion}m*/Makefile; do
      sed -i $i -e "s|-I/nix/store/[^ ']*||g" -e "s|-L/nix/store/[^ ']*||g" -e "s|$TMPDIR|/no-such-path|g"
    done
  '' + optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    # Determinism: rebuild all bytecode
    # We exclude lib2to3 because that's Python 2 code which fails
    # We rebuild three times, once for each optimization level
    find $out -name "*.py" | $out/bin/python -m compileall -q -f -x "lib2to3" -i -
    find $out -name "*.py" | $out/bin/python -O -m compileall -q -f -x "lib2to3" -i -
    find $out -name "*.py" | $out/bin/python -OO -m compileall -q -f -x "lib2to3" -i -
  '';

  passthru = let
    pythonPackages = callPackage ../../../../../top-level/python-packages.nix {python=self; overrides=packageOverrides;};
  in rec {
    inherit libPrefix sitePackages x11Support hasDistutilsCxxPatch;
    executable = "${libPrefix}m";
    buildEnv = callPackage ../../wrapper.nix { python = self; inherit (pythonPackages) requiredPythonModules; };
    withPackages = import ../../with-packages.nix { inherit buildEnv pythonPackages;};
    pkgs = pythonPackages;
    isPy3 = true;
    isPy36 = true;
    is_py3k = true;  # deprecated
    interpreter = "${self}/bin/${executable}";
  };

  enableParallelBuilding = true;

  doCheck = false; # expensive, and fails

  meta = {
    homepage = http://python.org;
    description = "A high-level dynamically-typed programming language";
    longDescription = ''
      Python is a remarkably powerful dynamic programming language that
      is used in a wide variety of application domains. Some of its key
      distinguishing features include: clear, readable syntax; strong
      introspection capabilities; intuitive object orientation; natural
      expression of procedural code; full modularity, supporting
      hierarchical packages; exception-based error handling; and very
      high level dynamic data types.
    '';
    license = licenses.psfl;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ fridh kragniz ];
  };
}
