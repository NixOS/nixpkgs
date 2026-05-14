{
  lib,
  stdenv,
  gccStdenv,
  clangStdenv,
  buildPackages,
  runCommandCC,
  makeBinaryWrapper,
  gcc,
  wild-unwrapped,
  binutils-unwrapped-all-targets,
  clang,
  lld,
  clang-tools,
  useWildLinker,
  hello,
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

  # Test helper that takes in a binary and checks that it runs
  # and was built with Wild
  helloTest =
    name: helloWild:
    let
      command = "$READELF -p .comment ${lib.getExe helloWild}";
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    runCommandCC "wild-${name}-test" { passthru = { inherit helloWild; }; } ''
      echo "Testing running the 'hello' binary which should be linked with 'wild'" >&2
      ${emulator} ${lib.getExe helloWild}

      echo "Checking for wild in the '.comment' section" >&2
      if output=$(${command} 2>&1); then
        if grep -Fw -- "Wild" - <<< "$output"; then
          touch $out
        else
          echo "No mention of 'wild' detected in the '.comment' section" >&2
          echo "The command was:" >&2
          echo "${command}" >&2
          echo "The output was:" >&2
          echo "$output" >&2
          exit 1
        fi
      else
        echo -n "${command}" >&2
        echo " returned a non-zero exit code." >&2
        echo "$output" >&2
        exit 1
      fi
    '';
in
{
  testWild = wild-unwrapped.overrideAttrs {
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

  # Test that the adapter works with a gcc stdenv
  adapterGcc = helloTest "adapter-gcc" (
    hello.override (_: {
      stdenv = useWildLinker gccStdenv;
    })
  );

  # Test the adapter works with a clang stdenv
  adapter-llvm = helloTest "adapter-llvm" (
    hello.override (_: {
      stdenv = useWildLinker clangStdenv;
    })
  );
}
