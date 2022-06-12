{ version, sha256 }:

{ lib, stdenv, fetchurl, fetchpatch, writeText, sbclBootstrap
, sbclBootstrapHost ? "${sbclBootstrap}/bin/sbcl --disable-debugger --no-userinit --no-sysinit"
, threadSupport ? (stdenv.hostPlatform.isx86 || "aarch64-linux" == stdenv.hostPlatform.system || "aarch64-darwin" == stdenv.hostPlatform.system)
, linkableRuntime ? stdenv.hostPlatform.isx86
, disableImmobileSpace ? false
  # Meant for sbcl used for creating binaries portable to non-NixOS via save-lisp-and-die.
  # Note that the created binaries still need `patchelf --set-interpreter ...`
  # to get rid of ${glibc} dependency.
, purgeNixReferences ? false
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "sbcl";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/project/sbcl/sbcl/${version}/${pname}-${version}-source.tar.bz2";
    inherit sha256;
  };

  buildInputs = [texinfo];

  patches = lib.optional
    (lib.versionAtLeast version "2.1.2" && lib.versionOlder version "2.1.8")
    (fetchpatch {
      # Fix segfault on ARM when reading large core files
      url = "https://github.com/sbcl/sbcl/commit/8fa3f76fba2e8572e86ac6fc5754e6b2954fc774.patch";
      sha256 = "1ic531pjnws1k3xd03a5ixbq8cn10dlh2nfln59k0vbm0253g3lv";
    });

  postPatch = ''
    echo '"${version}.nixos"' > version.lisp-expr

    # SBCL checks whether files are up-to-date in many places..
    # Unfortunately, same timestamp is not good enough
    sed -e 's@> x y@>= x y@' -i contrib/sb-aclrepl/repl.lisp
    #sed -e '/(date)/i((= date 2208988801) 2208988800)' -i contrib/asdf/asdf.lisp
    sed -i src/cold/slam.lisp -e \
      '/file-write-date input/a)'
    sed -i src/cold/slam.lisp -e \
      '/file-write-date output/i(or (and (= 2208988801 (file-write-date output)) (= 2208988801 (file-write-date input)))'
    sed -i src/code/target-load.lisp -e \
      '/date defaulted-fasl/a)'
    sed -i src/code/target-load.lisp -e \
      '/date defaulted-source/i(or (and (= 2208988801 (file-write-date defaulted-source-truename)) (= 2208988801 (file-write-date defaulted-fasl-truename)))'

    # Fix the tests
    sed -e '5,$d' -i contrib/sb-bsd-sockets/tests.lisp
    sed -e '5,$d' -i contrib/sb-simple-streams/*test*.lisp
  ''
  + (if purgeNixReferences
    then
      # This is the default location to look for the core; by default in $out/lib/sbcl
      ''
        sed 's@^\(#define SBCL_HOME\) .*$@\1 "/no-such-path"@' \
          -i src/runtime/runtime.c
      ''
    else
      # Fix software version retrieval
      ''
        sed -e "s@/bin/uname@$(command -v uname)@g" -i src/code/*-os.lisp \
          src/code/run-program.lisp
      ''
    );


  preBuild = ''
    export INSTALL_ROOT=$out
    mkdir -p test-home
    export HOME=$PWD/test-home
  '';

  enableFeatures = with lib;
    optional threadSupport "sb-thread" ++
    optional linkableRuntime "sb-linkable-runtime" ++
    optional stdenv.isAarch32 "arm";

  disableFeatures = with lib;
    optional (!threadSupport) "sb-thread" ++
    optionals disableImmobileSpace [ "immobile-space" "immobile-code" "compact-instance-header" ];

  buildPhase = ''
    runHook preBuild

    sh make.sh --prefix=$out --xc-host="${sbclBootstrapHost}" ${
                  lib.concatStringsSep " "
                    (builtins.map (x: "--with-${x}") enableFeatures ++
                     builtins.map (x: "--without-${x}") disableFeatures)
                } ${if stdenv.hostPlatform.system == "aarch64-darwin" then "--arch=arm64" else ""}
    (cd doc/manual ; make info)

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    INSTALL_ROOT=$out sh install.sh

    runHook postInstall
  ''
  + lib.optionalString (!purgeNixReferences) ''
    cp -r src $out/lib/sbcl
    cp -r contrib $out/lib/sbcl
    cat >$out/lib/sbcl/sbclrc <<EOF
     (setf (logical-pathname-translations "SYS")
       '(("SYS:SRC;**;*.*.*" #P"$out/lib/sbcl/src/**/*.*")
         ("SYS:CONTRIB;**;*.*.*" #P"$out/lib/sbcl/contrib/**/*.*")))
    EOF
  '';

  setupHook = lib.optional purgeNixReferences (writeText "setupHook.sh" ''
    addEnvHooks "$targetOffset" _setSbclHome
    _setSbclHome() {
      export SBCL_HOME='@out@/lib/sbcl/'
    }
  '');

  meta = sbclBootstrap.meta;
}
