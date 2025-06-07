{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  makeBinaryWrapper,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
  buildPackages,
  runCommandCC,
  testers,
  useWildLinker,
  clangStdenv,
  gccStdenv,
  clang,
  binutils-unwrapped-all-targets,
  gcc,
  glibc,
  lld,
  hello,
}:
let
  # Write a wrapper for GCC that passes -B to *unwrapped* binutils.
  # This ensures that if -fuse-ld=bfd is used, gcc picks up unwrapped ld.bfd
  # instead of the hardcoded wrapper search directory.
  # We pass it last because apparently gcc likes picking ld from the *first* -B,
  # which we want our wild target directory to be if passed.
  gccWrapper = stdenv.mkDerivation {
    inherit (gcc) meta name;
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
    meta = gcc.meta // {
      mainProgram = "g++";
    };
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  strictDeps = true;
  pname = "wild";
  version = "main";

  src = fetchFromGitHub {
    owner = "davidlattimore";
    repo = "wild";
    rev = "7c3737c5bae296bf3ed080ce9fba8db9015452a5";
    hash = "sha256-m3hGDS4Rfe73shrwHFtrTNiFSIuMdBhABddKWVzdE+E=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/davidlattimore/wild/pull/831.patch";
      hash = "sha256-UywEVaaqnin0PBsRqDLIZXSI6QdtQ9WHetuQrAfUlNo=";
    })
    (fetchpatch {
      url = "https://github.com/davidlattimore/wild/pull/843.patch";
      hash = "sha256-Uq03TzYyrRlZdAcdGfrO781vGM1GkAVoNdI96Vy/k5Y=";
    })
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-yHkWxC6ZXNnEhLdVfD6E15AvxM1AOUsdRT1YUTY+uPs=";

  cargoBuildFlags = [ "-p wild-linker" ];

  # wild's tests compare the outputs of several different linkers. nixpkgs's
  # patching and wrappers change the output behavior, so we must make sure
  # that their behavior is compatible.
  useNextest = true;
  checkInputs = [
    glibc.out
    glibc.static
  ];
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
      ]
    }:$PATH
  '';

  # TOOD: once v0.6.0 is released with the patches we need, switch to that and
  # start doing version checks
  doInstallCheck = false;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };

    tests =
      let
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
        version = testers.testVersion { package = finalAttrs.finalPackage; };
      }
      // lib.optionalAttrs stdenv.hostPlatform.isLinux {
        adapterGcc = helloTest "adapter-gcc" (
          hello.override (_: {
            stdenv = useWildLinker gccStdenv;
          })
        );

        adapter-llvm = helloTest "adapter-llvm" (
          hello.override (_: {
            stdenv = useWildLinker clangStdenv;
          })
        );
      };
  };

  meta = {
    changelog = "https://github.com/davidlattimore/wild/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Very fast linker for Linux";
    homepage = "https://github.com/davidlattimore/wild";
    license = [
      lib.licenses.asl20 # or
      lib.licenses.mit
    ];
    mainProgram = "wild";
    maintainers = with lib.maintainers; [ RossSmyth ];
    platforms = lib.platforms.linux;
  };
})
