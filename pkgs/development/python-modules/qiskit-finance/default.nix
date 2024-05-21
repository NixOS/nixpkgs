{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

  # Python Inputs
, fastdtw
, numpy
, pandas
, psutil
, qiskit-terra
, qiskit-optimization
, scikit-learn
, scipy
, quandl
, yfinance
  # Check Inputs
, pytestCheckHook
, ddt
, pytest-timeout
, qiskit-aer
}:

buildPythonPackage rec {
  pname = "qiskit-finance";
  version = "0.4.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "qiskit";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-zYhYhojCzlENzgYSenwewjeVHUBX2X6eQbbzc9znBsk=";
  };

  postPatch = ''
    substituteInPlace requirements.txt --replace "pandas<1.4.0" "pandas"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    fastdtw
    numpy
    pandas
    psutil
    qiskit-terra
    qiskit-optimization
    quandl
    scikit-learn
    scipy
    yfinance
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-timeout
    ddt
    qiskit-aer
  ];

  pythonImportsCheck = [ "qiskit_finance" ];
  disabledTests = [
    # Fail due to approximation error, ~1-2%
    "test_application"

    # Tests fail b/c require internet connection. Stalls tests if enabled.
    "test_exchangedata"
    "test_yahoo"
    "test_wikipedia"
  ];
  pytestFlagsArray = [
    "--durations=10"
  ];

  meta = with lib; {
    description = "Software for developing quantum computing programs";
    homepage = "https://qiskit.org";
    downloadPage = "https://github.com/QISKit/qiskit-optimization/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
