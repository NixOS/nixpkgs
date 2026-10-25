{
  callPackage,
  cmake,
  common-updater-scripts,
  curl,
  fetchFromGitHub,
  gnused,
  lib,
  markForCudatoolkitRootHook,
  nix,
  nix-update,
  stdenv,
  writeShellApplication,
}:
let
  inherit (lib.strings) cmakeBool;
in
# NOTE: Nothing here depends on the CUDA release (markForCudatoolkitRootHook is the same in every package set), so this
# is built with stdenv and without the CUDA name prefix: every CUDA package set from 12.9 on shares the same derivation.
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "nvtx";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "NVTX";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YyGZlP5rhU6bfViv3tSyXfak6fuE7zEzxVimzwS3IoI=";
  };

  # NOTE: The include output matches the layout of the redistributable.
  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  outputInclude = "include";

  nativeBuildInputs = [
    cmake
    markForCudatoolkitRootHook
  ];

  cmakeFlags = [ (cmakeBool "NVTX3_INSTALL" true) ];

  # The C and C++ APIs are header-only. The redistributable also ships libnvtx3interop, a library exporting the C API
  # for use from other languages (https://github.com/NVIDIA/NVTX#other-languages), which NVTX doesn't build. Build it
  # from the upstream test exporting the API; the test supplies minimal CUDA and OpenCL headers for the types used by
  # the naming functions.
  postBuild = ''
    nixLog "building libnvtx3interop"
    cat > libnvtx3interop.map <<'EOF'
    libnvtx3interop.so.1 {
      global: nvtx*;
      local: *;
    };
    EOF
    $CC -shared -fPIC -O2 \
      -DSUPPORT_EXTENSIONS \
      -I"$NIX_BUILD_TOP/$sourceRoot/c/include" \
      -I"$NIX_BUILD_TOP/$sourceRoot/tests/src/Imports/cuda_lite" \
      -I"$NIX_BUILD_TOP/$sourceRoot/tests/src/Imports/opencl_lite" \
      -Wl,-soname,libnvtx3interop.so.1 \
      -Wl,--version-script=libnvtx3interop.map \
      "$NIX_BUILD_TOP/$sourceRoot/tests/src/ExportApi.c" \
      -o libnvtx3interop.so.1.1.0
  '';

  # Named as in the CUDA 13 redistributables.
  postInstall = ''
    nixLog "installing libnvtx3interop"
    install -Dm755 libnvtx3interop.so.1.1.0 --target-directory="''${!outputLib:?}/lib"
    ln -sv libnvtx3interop.so.1.1.0 "''${!outputLib:?}/lib/libnvtx3interop.so.1"
    ln -sv libnvtx3interop.so.1 "''${!outputLib:?}/lib/libnvtx3interop.so"
  '';

  passthru = {
    # The Python package (python3Packages.nvtx) is built from python/ in the same source. It is versioned independently
    # of the C/C++ API; its version is in python/pyproject.toml.
    pythonVersion = "0.2.16";

    tests = {
      upstream = callPackage ./tests/upstream.nix { nvtx = finalAttrs.finalPackage; };
      cmake = callPackage ./tests/cmake.nix { nvtx = finalAttrs.finalPackage; };
    };

    updateScript = lib.getExe (writeShellApplication {
      name = "nvtx-update";
      runtimeInputs = [
        common-updater-scripts
        curl
        gnused
        nix
        nix-update
      ];
      text = ''
        # Releases are tagged both v<version> and v<version>-c-cpp.
        nix-update "$UPDATE_NIX_ATTR_PATH" --version-regex '^v([0-9]+\.[0-9]+\.[0-9]+)$'

        version=$(nix --extra-experimental-features nix-command eval --raw --file . "$UPDATE_NIX_ATTR_PATH.version")
        pythonVersion=$(
          curl -fsSL "https://raw.githubusercontent.com/NVIDIA/NVTX/v$version/python/pyproject.toml" |
            sed -nE 's/^version = "([^"]+)"$/\1/p'
        )
        if [[ -z "$pythonVersion" ]]; then
          echo "Could not determine the Python package version for NVTX $version" >&2
          exit 1
        fi

        update-source-version \
          "$UPDATE_NIX_ATTR_PATH" \
          "$pythonVersion" \
          --version-key=pythonVersion \
          --ignore-same-hash \
          --ignore-same-version
      '';
    });
  };

  meta = {
    description = "C-based Application Programming Interface (API) for annotating events, code ranges, and resources in your applications";
    longDescription = ''
      NVTX is a cross-platform API for annotating source code to provide contextual information to developer tools.

      The NVTX API is written in C, with wrappers provided for C++ and Python.
    '';
    homepage = "https://github.com/NVIDIA/NVTX";
    changelog = "https://github.com/NVIDIA/NVTX/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; WITH asl20 llvm-exception;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [
      GaetanLepage
      connorbaker
    ];
    teams = [ lib.teams.cuda ];
  };
})
