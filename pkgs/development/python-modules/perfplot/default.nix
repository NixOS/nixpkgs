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
  version = "0.9.6";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = pname;
    rev = "v${version}";
    sha256 = "11f31d6xqxp04693symc2dl8890gjaycrb2a35y5xy023abwir5b";
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
