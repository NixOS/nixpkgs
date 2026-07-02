{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,

  # dependencies
  gitpython,
  pytz,
  types-pytz,
  lizard,
}:

buildPythonPackage rec {
  pname = "pydriller";
  version = "2.10";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ishepard";
    repo = "pydriller";
    tag = version;
    hash = "sha256-Ooyn0Fjtz4J+BM+/LfknvRHTxnqDBxXVH4V9eNcDSTE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    gitpython
    pytz
    types-pytz
    lizard
  ];

  # require internet access
  doChecks = false;

  pythonImportsCheck = [ "pydriller" ];

  meta = {
    description = "Python Framework to analyse Git repositories";
    homepage = "https://pydriller.readthedocs.io/en/latest/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
