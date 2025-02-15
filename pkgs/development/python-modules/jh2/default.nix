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
  version = "5.0.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "h2";
    tag = "v${version}";
    hash = "sha256-H1i2lolctispLtQc+uqeE+NUeKr/dtgDq1zdTJH5gyU=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-nzLU6QhoJGNCqFF6pzzMr7FHbrLnNq7PvPC42VOrYo8=";
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
    maintainers = with lib.maintainers; [ fab ];
  };
}
