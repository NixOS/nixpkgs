{
  lib,
  stdenv,
  makeBinaryWrapper,
  gcc,
  wild,
  binutils-unwrapped-all-targets,
  clang,
  lld,
  clang-tools,
}:
let
  # These wrappers are REQUIRED for the Wild test suite to pass
  #
  # Write a wrapper for GCC that passes -B to *unwrapped* binutils.
  # This ensures that if -fuse-ld=bfd is used, gcc picks up unwrapped ld.bfd
  # instead of the hardcoded wrapper search directory.
  # We pass it last because apparently gcc likes picking ld from the *first* -B,
  # which we want our wild target directory to be if passed.
  gccWrapper = stdenv.mkDerivation {
    inherit (gcc) name;
    dontUnpack = true;
    dontConfigure = true;
    dontInstall = true;

    buildInputs = [ makeBinaryWrapper ];
    buildPhase = ''
      runHook preBuild

      makeWrapper ${lib.getExe gcc} $out/bin/gcc \
        --append-flag -B${binutils-unwrapped-all-targets}/bin

      runHook postBuild
    '';

  };

  gppWrapper = stdenv.mkDerivation {
    dontUnpack = true;
    dontConfigure = true;
    dontInstall = true;

    name = "g++-wrapped";
    buildInputs = [ makeBinaryWrapper ];
    buildPhase = ''
      runHook preBuild

      makeWrapper ${lib.getExe' gcc "g++"} $out/bin/g++ \
        --append-flag -B${binutils-unwrapped-all-targets}/bin

      runHook postBuild
    '';
  };
in
{
  testWild = wild.overrideAttrs {
    pname = "wild-tests";
    doCheck = true;
    doInstallCheck = false;
    dontBuild = true;
    buildType = "debug";

    checkInputs = [
      stdenv.cc.libc.out
      stdenv.cc.libc.static
    ];

    # https://github.com/davidlattimore/wild/discussions/832#discussioncomment-14482948
    checkFlags = lib.optionals stdenv.hostPlatform.isAarch64 [
      "--skip=integration_test::program_name_71___unresolved_symbols_object_c__"
    ];

    # wild's tests compare the outputs of several different linkers. nixpkgs's
    # patching and wrappers change the output behavior, so we must make sure
    # that their behavior is compatible.
    #
    # Does not work if they are put in nativeCheckInputs or checkInputs
    preCheck = ''
      export LD_LIBRARY_PATH=${
        lib.makeLibraryPath [
          stdenv.cc.cc.lib
        ]
      }:$LD_LIBRARY_PATH

      export PATH=${
        lib.makeBinPath [
          binutils-unwrapped-all-targets
          clang
          gccWrapper
          gppWrapper
          lld
          clang-tools
        ]
      }:$PATH
    '';

    installPhase = "touch $out";
  };
}
