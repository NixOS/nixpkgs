{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build
  setuptools,

  # runtime dependencies
  qiskit,
  qiskit-algorithms,
  qiskit-optimization,
  scipy,
  numpy,
  psutil,
  fastdtw,
  pandas,
  nasdaq-data-link,
  yfinance,
  certifi,
  urllib3,

  # test dependencies
  pytestCheckHook,
  ddt,
  pytest-timeout,
  qiskit-aer,
}:

buildPythonPackage (finalAttrs: {
  pname = "qiskit-finance";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qiskit";
    repo = "qiskit-finance";
    tag = finalAttrs.version;
    hash = "sha256-zYhYhojCzlENzgYSenwewjeVHUBX2X6eQbbzc9znBsk=";
  };

  patches = [
    # Backport upstream's test and README migration to V2 primitives for Qiskit >= 2.0.
    # https://github.com/qiskit-community/qiskit-finance/pull/353
    (fetchpatch {
      url = "https://github.com/qiskit-community/qiskit-finance/commit/ae42cb8db871c0becf3572551cd4f4903861828b.patch";
      includes = [
        "README.md"
        "test/circuit/test_european_call_delta_objective.py"
        "test/circuit/test_european_call_pricing_objective.py"
        "test/circuit/test_fixed_income_pricing_objective.py"
      ];
      hash = "sha256-OgbpftLry40iafu4oSsnQ0WzHr/h+wWWddnFMTYn7PY=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  dependencies = [
    qiskit
    qiskit-algorithms
    qiskit-optimization
    scipy
    numpy
    psutil
    fastdtw
    pandas
    nasdaq-data-link
    yfinance
    certifi
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-timeout
    ddt
    qiskit-aer
  ];

  pythonImportsCheck = [
    "qiskit_finance"
    "qiskit_finance.data_providers"
  ];
  disabledTests = [
    # Fail due to approximation error, ~1-2%
    "test_application"

    # Tests fail b/c require internet connection. Stalls tests if enabled.
    "test_exchangedata"
    "test_yahoo"
    "test_wikipedia"

    # Test fails due to non-determinism/no seed set
    "test_readme_sample"
  ];
  pytestFlags = [ "--durations=10" ];

  meta = {
    description = "Software for developing quantum computing programs";
    homepage = "https://qiskit.org";
    downloadPage = "https://github.com/qiskit-community/qiskit-finance/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ chemonke ];
  };
})
