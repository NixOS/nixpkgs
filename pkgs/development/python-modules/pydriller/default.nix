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
  version = "2.11";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ishepard";
    repo = "pydriller";
    tag = version;
    hash = "sha256-p4caHh95PnmWLC2fiSX8BCxfLymxSUUNIdxIWOc8O5w=";
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
