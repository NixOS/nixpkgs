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
  # nixpkgs-update: no auto update
  version = "0.13.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "NiaARM";
    tag = version;
    hash = "sha256-524rJ5b9e0U1rqu1iCGMA3Tgnn9bO4biCC1FMoGNqms=";
  };

  pythonRelaxDeps = [
    "numpy"
    "plotly"
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
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  disabledTests = [
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
    changelog = "https://github.com/firefly-cpp/NiaARM/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ firefly-cpp ];
  };
}
