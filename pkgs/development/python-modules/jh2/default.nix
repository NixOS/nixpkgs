{
  lib,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  hypothesis,
  pytestCheckHook,
  rustc,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "jh2";
  version = "5.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "h2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k69U8O0c7z1TJASOWcndZA/LYTsX7nVfelhaS6FlN5g=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ELZD3CIAv70DGoCgdK8T2yVLtib9ylSvoZPFOge6nIQ=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jh2" ];

  meta = {
    description = "HTTP/2 State-Machine based protocol implementation";
    homepage = "https://github.com/jawah/h2";
    changelog = "https://github.com/jawah/h2/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      techknowlogick
    ];
  };
})
