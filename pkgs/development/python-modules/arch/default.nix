{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  numpy,
  pandas,
  property-cached,
  pytestCheckHook,
  scipy,
  setuptools,
  setuptools-scm,
  statsmodels,
}:

buildPythonPackage rec {
  pname = "arch";
  version = "7.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bashtage";
    repo = "arch";
    tag = "v${version}";
    hash = "sha256-3H/6mdPg8rg+N1wecqLDzc7Ot3SnUVpOagns4PsTD/Q=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace 'PytestRemovedIn8Warning' 'PytestRemovedIn9Warning'
  '';

  build-system = [
    setuptools
    setuptools-scm
    cython
  ];

  dependencies = [
    numpy
    pandas
    property-cached
    scipy
    statsmodels
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Skip long-running/failing tests
    "arch/tests/univariate/test_forecast.py"
    "arch/tests/univariate/test_mean.py"
  ];

  pythonImportsCheck = [ "arch" ];

  meta = {
    description = "Autoregressive Conditional Heteroskedasticity (ARCH) and other tools for financial econometrics";
    homepage = "https://github.com/bashtage/arch";
    changelog = "https://github.com/bashtage/arch/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
