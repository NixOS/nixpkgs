{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # nativeBuildInputs
  rustPlatform,
  cmake,
  nasm,

  # tests
  numpy,
  pytestCheckHook,
  torch,
}:

buildPythonPackage rec {
  pname = "kornia-rs";
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kornia";
    repo = "kornia-rs";
    tag = "v${version}";
    hash = "sha256-0Id1Iyd/xyqSqFvg/TXnlX1DgMUWuMS9KbtDXduwU+Y=";
  };

  nativeBuildInputs = [
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
    cmake # Only for dependencies.
    nasm # Only for dependencies.
  ];

  cargoRoot = "kornia-py";
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} kornia-py/Cargo.lock
  '';

  maturinBuildFlags = [
    "-m"
    "kornia-py/Cargo.toml"
  ];

  dontUseCmakeConfigure = true; # We only want to use CMake to build some Rust dependencies.

  nativeCheckInputs = [
    numpy
    pytestCheckHook
    torch
  ];

  meta = {
    homepage = "https://github.com/kornia/kornia-rs";
    description = "Python bindings to Low-level Computer Vision library in Rust";
    changelog = "https://github.com/kornia/kornia-rs/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ chpatrick ];
    badPlatforms = [
      # error: could not compile `kornia-3d` (lib)
      # error: rustc interrupted by SIGSEGV
      "aarch64-linux"
    ];
  };
}
