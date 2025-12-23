{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  joblib,
  matplotlib,
  meson-python,
  numpy,
  pandas,
  scikit-learn,
  scipy,
  statsmodels,
  urllib3,
  python,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pmdarima";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alkaline-ml";
    repo = "pmdarima";
    tag = "v${version}";
    hash = "sha256-NSBmii+2AQidZo8sPARxtLELk5Ec6cHaZddswifFqwQ=";
  };

  postPatch = ''
    patchShebangs build_tools/get_tag.py
  '';

  env = {
    GITHUB_REF = "refs/tags/v${version}";
  };

  build-system = [
    cython
    meson-python
  ];

  pythonRemoveDeps = [
    # https://github.com/alkaline-ml/pmdarima/pull/616
    "setuptools"
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
    pytestCheckHook
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
