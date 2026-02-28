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
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = "diffsync";
    tag = "v${version}";
    hash = "sha256-REraWLk00+gCUqCV7wOed3+kXs+T1/qzecW1WFGD/10=";
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

  meta = {
    description = "Utility library for comparing and synchronizing different datasets";
    homepage = "https://github.com/networktocode/diffsync";
    changelog = "https://github.com/networktocode/diffsync/blob/${src.tag}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ clerie ];
  };
}
