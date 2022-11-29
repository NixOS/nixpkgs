{ lib, stdenv, fetchurl, fetchpatch, writeText, sbclBootstrap, zstd
, sbclBootstrapHost ? "${sbclBootstrap}/bin/sbcl --disable-debugger --no-userinit --no-sysinit"
, threadSupport ? (stdenv.hostPlatform.isx86 || "aarch64-linux" == stdenv.hostPlatform.system || "aarch64-darwin" == stdenv.hostPlatform.system)
, linkableRuntime ? stdenv.hostPlatform.isx86
, disableImmobileSpace ? false
  # Meant for sbcl used for creating binaries portable to non-NixOS via save-lisp-and-die.
  # Note that the created binaries still need `patchelf --set-interpreter ...`
  # to get rid of ${glibc} dependency.
, purgeNixReferences ? false
, coreCompression ? lib.versionAtLeast version "2.2.6"
, texinfo
, version
}:

let
  versionMap = {
    "2.0.9" = {
      sha256 = "17wvrcwgp45z9b6arik31fjnz7908qhr5ackxq1y0gqi1hsh1xy4";
    };

    "2.1.11" = {
      sha256 = "1zgypmn19c58pv7j33ga7m1l7lzghj70w3xbybpgmggxwwflihdz";
    };

    "2.2.11" = {
      sha256 = "sha256-NgfWgBZzGICEXO1dXVXGBUzEnxkSGhUCfmxWB66Elt8=";
    };
  };

in with versionMap.${version};

stdenv.mkDerivation rec {
  pname = "sbcl";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/project/sbcl/sbcl/${version}/${pname}-${version}-source.tar.bz2";
    inherit sha256;
  };

  nativeBuildInputs = [ texinfo ];
  buildInputs = lib.optionals coreCompression [ zstd ];

  patches = lib.optionals (version == "2.1.11") [
      # Fix included in SBCL trunk since 2.2.9:
      #   https://bugs.launchpad.net/sbcl/+bug/1980570
      (fetchpatch {
        name = "darwin-fno-common.patch";
        url = "https://bugs.launchpad.net/sbcl/+bug/1980570/+attachment/5600916/+files/0001-src-runtime-fix-fno-common-build-on-darwin.patch";
        sha256 = "0avpwgjdaxxdpq8pfvv9darfn4ql5dgqq7zaf3nmxnvhh86ngzij";
      })
      # Fix -fno-common on arm64
      (fetchpatch {
        name = "arm64-fno-common.patch";
        url = "https://github.com/sbcl/sbcl/commit/ac3739eae36de92feffef5bb9b4b4bd93f6c4942.patch";
        sha256 = "1kxg0ng7d465rk5v4biikrzaps41x4n1v4ygnb5qh4f5jzkbms8y";
      })
  ];

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
    optional coreCompression "sb-core-compression" ++
    optional stdenv.isAarch32 "arm";

  disableFeatures = with lib;
    optional (!threadSupport) "sb-thread" ++
    optionals disableImmobileSpace [ "immobile-space" "immobile-code" "compact-instance-header" ];

  NIX_CFLAGS_COMPILE = lib.optionals (lib.versionOlder version "2.1.10") [
    # Workaround build failure on -fno-common toolchains like upstream
    # clang-13. Without the change build fails as:
    #   duplicate symbol '_static_code_space_free_pointer' in: alloc.o traceroot.o
    # Should be fixed past 2.1.10 release.
    "-fcommon"
  ];

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
