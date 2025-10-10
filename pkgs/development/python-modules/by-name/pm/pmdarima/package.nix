{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  joblib,
  matplotlib,
  numpy,
  pandas,
  scikit-learn,
  scipy,
  statsmodels,
  urllib3,
  pythonOlder,
  python,
  pytest7CheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pmdarima";
  version = "2.0.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alkaline-ml";
    repo = "pmdarima";
    tag = "v${version}";
    hash = "sha256-LHwPgQRB/vP3hBM8nqafoCrN3ZSRIMWLzqTqDOETOEc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy==" "numpy>=" \
      --replace-fail "scipy==" "scipy>=" \
      --replace-fail "statsmodels==" "statsmodels>="
  '';

  env = {
    GITHUB_REF = "refs/tags/v${version}";
  };

  preBuild = ''
    python build_tools/get_tag.py
  '';

  nativeBuildInputs = [ cython ];

  build-system = [
    setuptools
  ];

  dependencies = [
    joblib
    numpy
    pandas
    scikit-learn
    scipy
    statsmodels
    urllib3
  ];

  # Make sure we're running the tests for the actually installed
  # package, so that cython's compiled files are available.
  preCheck = ''
    cd $out/${python.sitePackages}
  '';

  nativeCheckInputs = [
    matplotlib
    pytest7CheckHook
  ];

  disabledTests = [
    # touches internet
    "test_load_from_web"
  ];

  pythonImportsCheck = [ "pmdarima" ];

  meta = {
    description = "Statistical library designed to fill the void in Python's time series analysis capabilities, including the equivalent of R's auto.arima function";
    homepage = "https://github.com/alkaline-ml/pmdarima";
    changelog = "https://github.com/alkaline-ml/pmdarima/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mbalatsko ];
  };
}
