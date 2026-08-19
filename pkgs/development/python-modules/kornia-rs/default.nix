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
  version = "0.1.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kornia";
    repo = "kornia-rs";
    tag = "v${version}";
    hash = "sha256-xzJkuWhSQe5V+I4dKNoGflbt7cARewtEbTdJ3YY+cm8=";
  };

  nativeBuildInputs = [
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
    cmake # Only for dependencies.
    nasm # Only for dependencies.
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      ;
    hash = "sha256-hnvPKm0ul1IXKFtVe1j0D6ogXQ44wpDFpeWn/p5ZKeA=";
  };

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

  disabledTests = [
    # requires apriltag-imgs submodule
    "test_apriltag_decoder"
  ];

  meta = {
    homepage = "https://github.com/kornia/kornia-rs";
    description = "Python bindings to Low-level Computer Vision library in Rust";
    changelog = "https://github.com/kornia/kornia-rs/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ chpatrick ];
  };
}
