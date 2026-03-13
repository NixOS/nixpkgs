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
  version = "8.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bashtage";
    repo = "arch";
    tag = "v${version}";
    hash = "sha256-qw8sSgsMu6YTiQlzsrePnDKkFBtrxD9RK6ZZE5jFeX0=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail 'PytestRemovedIn8Warning' 'PytestRemovedIn9Warning'
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools_scm[toml]>=8.0.3,<9",' '"setuptools_scm[toml]",'
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
    changelog = "https://github.com/bashtage/arch/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
