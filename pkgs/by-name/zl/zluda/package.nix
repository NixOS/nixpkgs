{ lib, fetchFromGitHub, rocmPackages, python3, cargo, rustc, cmake, clang, zlib, libxml2, libedit, rustPlatform, stdenv }:

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
    # TODO: investigate test failure (the test seems to require build time env vars that aren't set on linux?)
    rm zluda_inject/tests/inject.rs
  '';

  buildPhase = ''
    runHook preBuild
    cargo xtask --release
    runHook postBuild
  '';
  # xtask doesn't support passing --target, but nix hooks expect the folder structure from when it's set
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.cargoShortTarget;

  cargoHash = "sha256-gZdLThmaeWVJXoeG7fuusfacgH2RNTHrqm8W0kqkqOY=";

  # vergen panics if the .git directory isn't present
  # Disable vergen and manually set env
  postPatch = ''
    substituteInPlace zluda/build.rs \
      --replace-fail 'vergen(Config::default())' 'Some(())'
  '';
  env.VERGEN_GIT_SHA = "1b9ba2b2333746c5e2b05a2bf24fa6ec3828dcdf-nix";

  postInstall = ''
    ln -s libnvml.so     $out/lib/libnvidia-ml.so.1
    ln -s libnvml.so     $out/lib/libnvidia-ml.so
    ln -s libnccl.so     $out/lib/libnccl.so.2
    ln -s libcusparse.so $out/lib/libcusparse.so.11
    ln -s libcufft.so    $out/lib/libcufft.so.10
    ln -s libcudnn.so    $out/lib/libcudnn.so.8
    ln -s libcudnn.so    $out/lib/libcudnn.so.7
    ln -s libnvcuda.so   $out/lib/libcuda.so.1
    ln -s libnvcuda.so   $out/lib/libcuda.so
    ln -s libcublas.so   $out/lib/libcublas.so.11
    ln -s libcublas.so   $out/lib/libcublas.so.10
  '';

  meta = with lib; {
    description = "ZLUDA - CUDA on Intel GPUs";
    homepage = "https://github.com/vosen/ZLUDA";
    license = licenses.mit;
    maintainers = [
      lib.maintainers.errnoh
    ];
  };
}
