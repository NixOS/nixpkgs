{
  lib,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  hypothesis,
  pytestCheckHook,
  pythonOlder,
  rustc,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "jh2";
  version = "5.0.10";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "h2";
    tag = "v${version}";
    hash = "sha256-zytQ6UFNeIaF7cftp7C/RnXhuRbQxc1jhwVmFwUDF1Y=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-W2BfuOhYL56gPd+j9YuJ7Ee3e+jT5m47h8qXihoMu1M=";
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
    changelog = "https://github.com/jawah/h2/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      techknowlogick
    ];
  };
}
