{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  formulaic,
  mypy-extensions,
  numpy,
  pandas,
  pyhdfe,
  pytestCheckHook,
  scipy,
  setuptools,
  setuptools-scm,
  statsmodels,
}:

buildPythonPackage rec {
  pname = "linearmodels";
  version = "6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bashtage";
    repo = "linearmodels";
    tag = "v${version}";
    hash = "sha256-oWVBsFSKnv/8AHYP5sxO6+u5+hsOw/uQlOetse5ue88=";
  };

  build-system = [
    setuptools
    setuptools-scm
    cython
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  dependencies = [
    formulaic
    mypy-extensions
    numpy
    pandas
    pyhdfe
    scipy
    statsmodels
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "linearmodels" ];

  meta = {
    description = "Models for panel data, system regression, instrumental variables and asset pricing";
    homepage = "https://bashtage.github.io/linearmodels/";
    changelog = "https://github.com/bashtage/linearmodels/releases/tag/v${version}";
    license = lib.licenses.ncsa;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
