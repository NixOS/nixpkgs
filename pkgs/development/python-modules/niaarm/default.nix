{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  niapy,
  nltk,
  numpy,
  pandas,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  tomli,
}:

buildPythonPackage rec {
  pname = "niaarm";
  version = "0.3.9";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "NiaARM";
    rev = "refs/tags/${version}";
    hash = "sha256-J3126RSJYBCSyxoPsvsDgmx9E+9fP2h6avPiCHISL7c=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    niapy
    nltk
    numpy
    pandas
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
    changelog = "https://github.com/firefly-cpp/NiaARM/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
