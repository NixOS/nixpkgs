{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  niapy,
  nltk,
  numpy,
  pandas,
  plotly,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  scikit-learn,
  tomli,
}:

buildPythonPackage rec {
  pname = "niaarm";
  version = "0.13.4";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "NiaARM";
    tag = version;
    hash = "sha256-524rJ5b9e0U1rqu1iCGMA3Tgnn9bO4biCC1FMoGNqms=";
  };

  pythonRelaxDeps = [
    "numpy"
    "scikit-learn"
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    niapy
    nltk
    numpy
    pandas
    plotly
    scikit-learn
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  disabledTests = [
    # Test requires extra nltk data dependency
    "test_text_mining"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "niaarm" ];

  meta = with lib; {
    description = "Minimalistic framework for Numerical Association Rule Mining";
    mainProgram = "niaarm";
    homepage = "https://github.com/firefly-cpp/NiaARM";
    changelog = "https://github.com/firefly-cpp/NiaARM/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
