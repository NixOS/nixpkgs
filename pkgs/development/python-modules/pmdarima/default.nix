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
}:

buildPythonPackage rec {
  pname = "pmdarima";
  version = "2.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alkaline-ml";
    repo = "pmdarima";
    rev = "refs/tags/v${version}";
    hash = "sha256-LHwPgQRB/vP3hBM8nqafoCrN3ZSRIMWLzqTqDOETOEc=";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Statistical library designed to fill the void in Python's time series analysis capabilities, including the equivalent of R's auto.arima function";
    homepage = "https://github.com/alkaline-ml/pmdarima";
    changelog = "https://github.com/alkaline-ml/pmdarima/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
