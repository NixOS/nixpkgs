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

buildPythonPackage (finalAttrs: {
  pname = "pydriller";
  version = "2.12";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ishepard";
    repo = "pydriller";
    tag = finalAttrs.version;
    hash = "sha256-5zBb9z2+Hvkf/XdA9SOMcEQwcSE/r4jg9vW+mpPc5wM=";
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
})
