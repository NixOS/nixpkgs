{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, joblib
, numpy
, pandas
, scikit-learn
, scipy
, statsmodels
, urllib3
, pythonOlder
, python
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pmdarima";
  version = "2.0.3";
  format = "setuptools";

  disable = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alkaline-ml";
    repo = "pmdarima";
    rev = "v${version}";
    hash = "sha256-uX4iZZ2deYqVWnqVZT6J0Djf2pXo7ug4MsOsPkKjvSU=";
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
    cd $out/lib/${python.libPrefix}/site-packages
  '';

  nativeCheckInputs = [ pytestCheckHook ];
  disabledTests= [
    # touches internet
    "test_load_from_web"
  ];

  pythonImportsCheck = [ "pmdarima" ];

  meta = with lib; {
    description = "A statistical library designed to fill the void in Python's time series analysis capabilities, including the equivalent of R's auto.arima function";
    homepage = "https://github.com/alkaline-ml/pmdarima";
    changelog = "https://github.com/alkaline-ml/pmdarima/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
