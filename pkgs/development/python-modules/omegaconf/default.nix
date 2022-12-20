{ lib
, antlr4_9-python3-runtime
, buildPythonPackage
, fetchFromGitHub
, jre_minimal
, pydevd
, pytest-mock
, pytestCheckHook
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "omegaconf";
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "omry";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Qxa4uIiX5TAyQ5rFkizdev60S4iVAJ08ES6FpNqf8zI=";
  };

  nativeBuildInputs = [
    jre_minimal
  ];

  propagatedBuildInputs = [
    antlr4_9-python3-runtime
    pyyaml
  ];

  checkInputs = [
    pydevd
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "omegaconf"
  ];

  meta = with lib; {
    description = "Framework for configuring complex applications";
    homepage = "https://github.com/omry/omegaconf";
    changelog = "https://github.com/omry/omegaconf/blob/v${version}/NEWS.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
