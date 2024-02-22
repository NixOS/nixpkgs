{ lib, fetchFromGitHub, rocmPackages, python3, cargo, rustc, cmake, clang, zlib, libxml2, libedit, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "zluda";
  version = "3";

  src = fetchFromGitHub {
    owner = "vosen";
    repo = "ZLUDA";
    rev = "v${version}";
    hash = "sha256-lykM18Ml1eeLMj/y6uPk34QOeh7Y59i1Y0Nr118Manw=";
    fetchSubmodules = true;
  };

  cargoPatches = [ ./ZLUDA-cargo.lock.patch ];

  buildInputs = [
    rocmPackages.clr
    rocmPackages.miopen
    rocmPackages.rocm-smi
    rocmPackages.rocsparse
    rocmPackages.rocsolver
    rocmPackages.rocblas
    rocmPackages.hipblas
    rocmPackages.rocm-cmake
    rocmPackages.hipfft
  ];

  nativeBuildInputs = [
    python3
    cargo
    rustc
    cmake
    clang
    zlib
    libxml2
    libedit
  ];

  preConfigure = ''
    # Comment out zluda_blaslt in Cargo.toml
    sed -i '/zluda_blaslt/d' Cargo.toml
  '';

  buildPhase = ''
    runHook preBuild
    cargo xtask --release
    runHook postBuild
  '';

  cargoHash = "sha256-gZdLThmaeWVJXoeG7fuusfacgH2RNTHrqm8W0kqkqOY=";

  meta = with lib; {
    description = "ZLUDA - CUDA on Intel GPUs";
    homepage = "https://github.com/vosen/ZLUDA";
    license = licenses.mit;
    maintainers = [
      lib.maintainers.errnoh
    ];
  };
}
