{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  gitMinimal,
  nix-update-script,
  python3,
  python3Packages,
  zlib,
  libxml2,
  ncurses,
}:

stdenv.mkDerivation {
  pname = "torch-mlir";
  version = "0-unstable-2026-02-12";

  src = fetchFromGitHub {
    owner = "llvm";
    repo = "torch-mlir";
    rev = "59c249e5cc2025acca81bdcf1596b8dd36a5c0f9";
    fetchSubmodules = true;
    hash = "sha256-o1HG5JuKRMEnl2PrEu5KQi4iqBe0Doh1SET2W/OjGoI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    gitMinimal
    python3
    python3Packages.nanobind
  ];

  buildInputs = [
    zlib
    libxml2
    ncurses
  ];

  configurePhase = ''
    runHook preConfigure

    cmake -G Ninja \
      -S externals/llvm-project/llvm \
      -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=$out \
      -DLLVM_ENABLE_ASSERTIONS=ON \
      -DMLIR_ENABLE_BINDINGS_PYTHON=ON \
      -DLLVM_TARGETS_TO_BUILD=host \
      -DLLVM_ENABLE_PROJECTS=mlir \
      -DLLVM_EXTERNAL_PROJECTS=torch-mlir \
      -DLLVM_EXTERNAL_TORCH_MLIR_SOURCE_DIR=$PWD \
      -DPython3_EXECUTABLE=${python3}/bin/python3 \
      -DPython_EXECUTABLE=${python3}/bin/python3 \
      -DPython3_FIND_VIRTUALENV=ONLY \
      -DPython_FIND_VIRTUALENV=ONLY

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    cmake --build build --target tools/torch-mlir/all TorchMLIRPythonModules -- -j''${NIX_BUILD_CORES:-1}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    for component in torch-mlir-headers torch-mlir-opt torch-mlir-lsp-server TorchMLIRPythonModules; do
      cmake --install build --prefix "$out" --component "$component"
    done

    if [ -d "$out/python_packages" ]; then
      mv "$out/python_packages" "$out/python-packages"
    fi

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Torch-MLIR compiler infrastructure and Python bindings";
    homepage = "https://github.com/llvm/torch-mlir";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ rcoeurjoly ];
  };
}
