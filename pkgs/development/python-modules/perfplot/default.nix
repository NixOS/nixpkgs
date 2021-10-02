{ lib
, buildPythonPackage
, fetchFromGitHub
, dufte
, matplotlib
, numpy
, pipdate
, tqdm
, rich
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "perfplot";
  version = "0.9.8";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = pname;
    rev = version;
    sha256 = "17dpgd27ik7ka7xpk3mj3anbjj62lwygy1vxlmrmk8xbhrqkim8d";
  };
  format = "pyproject";

  propagatedBuildInputs = [
    dufte
    matplotlib
    numpy
    pipdate
    rich
    tqdm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "perfplot" ];

  meta = with lib; {
    description = "Performance plots for Python code snippets";
    homepage = "https://github.com/nschloe/perfplot";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
