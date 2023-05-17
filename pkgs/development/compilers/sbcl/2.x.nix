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
    # Only kept around for BCLM. Remove once unneeded there.
    "2.1.9" = {
      sha256 = "189gjqzdz10xh3ybiy4ch1r98bsmkcb4hpnrmggd4y2g5kqnyx4y";
    };

    # The loosely held nixpkgs convention for SBCL is to keep the last two
    # versions.
    # https://github.com/NixOS/nixpkgs/pull/200994#issuecomment-1315042841
    "2.3.2" = {
      sha256 = "sha256-RMwWLPpjMqmojHoSHRkDiCikuk9r/7d+8cexdAfLHqo=";
    };

    "2.3.4" = {
      sha256 = "sha256-8RtHZMbqvbJ+WpxGshcgTRG82lNOc7+XBz1Xgx0gnE4=";
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

  # There are no patches necessary for the currently enabled versions, but this
  # code is left in place for the next potential patch.
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

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals (lib.versionOlder version "2.1.10") [
    # Workaround build failure on -fno-common toolchains like upstream
    # clang-13. Without the change build fails as:
    #   duplicate symbol '_static_code_space_free_pointer' in: alloc.o traceroot.o
    # Should be fixed past 2.1.10 release.
    "-fcommon"
  ]
    # Fails to find `O_LARGEFILE` otherwise.
    ++ [ "-D_GNU_SOURCE" ]);

  buildPhase = ''
    runHook preBuild

    sh make.sh --prefix=$out --xc-host="${sbclBootstrapHost}" ${
                  lib.concatStringsSep " "
                    (builtins.map (x: "--with-${x}") enableFeatures ++
                     builtins.map (x: "--without-${x}") disableFeatures)
                } ${lib.optionalString (stdenv.hostPlatform.system == "aarch64-darwin") "--arch=arm64"}
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
