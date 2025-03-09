{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  niapy,
  nltk,
  numpy,
  pandas,
  plotly,
  scikit-learn,
  pythonOlder,
  tomli,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "niaarm";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "NiaARM";
    tag = version;
    hash = "sha256-/lEW6SUV+CRovYmLVWiolYDHYmMJSJHnYNo9+lBc9nY=";
  };

  pythonRelaxDeps = [
    "numpy"
    "scikit-learn"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    niapy
    nltk
    numpy
    pandas
    plotly
    scikit-learn
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  disabledTests =
    [
      # Test requires extra nltk data dependency
      "test_text_mining"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Fatal Python error: Aborted
      # matplotlib/backend_bases.py", line 2654 in create_with_canvas
      "test_hill_slopes"
      "test_two_key_plot"
    ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "niaarm" ];

  meta = {
    description = "Minimalistic framework for Numerical Association Rule Mining";
    mainProgram = "niaarm";
    homepage = "https://github.com/firefly-cpp/NiaARM";
    changelog = "https://github.com/firefly-cpp/NiaARM/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ firefly-cpp ];
  };
}
