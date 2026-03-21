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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zluda";
  version = "6-preview.55";

  src = fetchFromGitHub {
    owner = "vosen";
    repo = "ZLUDA";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yhWEzoDjNk1GefSqOVwowNky36ahmH/gTMdq1YTOhfE=";
    fetchSubmodules = true;
    fetchLFS = true;
  };

  buildInputs = [
    rocmPackages.clr
    rocmPackages.miopen
    rocmPackages.rocm-smi
    rocmPackages.rocsparse
    rocmPackages.rocsolver
    rocmPackages.rocblas
    rocmPackages.hipblas
    rocmPackages.hipblaslt
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

  cargoHash = "sha256-YNBeweZ/vfXGfM0lrZbAh71z6Rb0+B7nOuO8VL2BmCo=";

  # Tests require a GPU and segfault in the sandbox
  doCheck = false;

  # xtask doesn't support passing --target, but nix hooks expect the folder structure from when it's set
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.cargoShortTarget;
  # Future packagers:
  # This is a fix for https://github.com/NixOS/nixpkgs/issues/390469. Ideally
  # ZLUDA should configure this automatically. Therefore, on every new update,
  # please try removing this line and see if ZLUDA builds.
  env.CMAKE_BUILD_TYPE = "Release";

  preConfigure = ''
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
    description = "CUDA on non-Nvidia GPUs";
    homepage = "https://github.com/vosen/ZLUDA";
    changelog = "https://github.com/vosen/ZLUDA/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.errnoh
    ];
  };
})
