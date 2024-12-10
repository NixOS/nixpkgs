{
  lib,
  fetchFromGitHub,
  rocmPackages,
  python3,
  cargo,
  rustc,
  cmake,
  clang,
  zlib,
  libxml2,
  libedit,
  rustPlatform,
  stdenv,
}:

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
    zlib
    libxml2
    libedit
  ];

  nativeBuildInputs = [
    python3
    cargo
    rustc
    cmake
    clang
  ];

  cargoHash = "sha256-gZdLThmaeWVJXoeG7fuusfacgH2RNTHrqm8W0kqkqOY=";
  cargoLock.lockFile = ./Cargo.lock;

  # xtask doesn't support passing --target, but nix hooks expect the folder structure from when it's set
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.cargoShortTarget;

  # vergen panics if the .git directory isn't present
  # Disable vergen and manually set env
  postPatch = ''
    substituteInPlace zluda/build.rs \
      --replace-fail 'vergen(Config::default())' 'Some(())'
    # ZLUDA repository missing Cargo.lock: vosen/ZLUDA#43
    ln -s ${./Cargo.lock} Cargo.lock
  '';
  env.VERGEN_GIT_SHA = src.rev;

  preConfigure = ''
    # Comment out zluda_blaslt in Cargo.toml until hipBLASLt package is added: https://github.com/NixOS/nixpkgs/issues/197885#issuecomment-2046178008
    sed -i '/zluda_blaslt/d' Cargo.toml
    # disable test written for windows only: https://github.com/vosen/ZLUDA/blob/774f4bcb37c39f876caf80ae0d39420fa4bc1c8b/zluda_inject/tests/inject.rs#L55
    rm zluda_inject/tests/inject.rs
  '';

  buildPhase = ''
    runHook preBuild
    cargo xtask --release
    runHook postBuild
  '';

  preInstall = ''
    mkdir -p $out/lib/
    find target/release/ -maxdepth 1 -type l -name '*.so*' -exec \
      cp --recursive --no-clobber --target-directory=$out/lib/ {} +
  '';

  meta = {
    description = "ZLUDA - CUDA on Intel GPUs";
    homepage = "https://github.com/vosen/ZLUDA";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.errnoh
    ];
  };
}
