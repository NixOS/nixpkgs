{
  lib,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  packaging,
  poetry-core,
  pydantic,
  redis,
  structlog,
}:

buildPythonPackage rec {
  pname = "diffsync";
  version = "2.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = "diffsync";
    tag = "v${version}";
    hash = "sha256-UZpGWa/UjHXp6jD0fPNWTMl1DZ1AWmILRX/5XRIpLdE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "packaging"
    "structlog"
  ];

  propagatedBuildInputs = [
    colorama
    packaging
    pydantic
    redis
    structlog
  ];

  pythonImportsCheck = [ "diffsync" ];

  meta = with lib; {
    description = "Utility library for comparing and synchronizing different datasets";
    homepage = "https://github.com/networktocode/diffsync";
    changelog = "https://github.com/networktocode/diffsync/blob/${src.tag}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ clerie ];
  };
}
