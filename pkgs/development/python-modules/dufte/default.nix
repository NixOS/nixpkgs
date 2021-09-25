{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, importlib-metadata
, matplotlib
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dufte";
  version = "0.2.27";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = pname;
    rev = version;
    sha256 = "1i68h224hx9clxj3l0rd2yigsi6fqsr3x10vj5hf3j6s69iah7r3";
  };
  format = "pyproject";

  propagatedBuildInputs = [
    matplotlib
    numpy
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dufte" ];

  meta = with lib; {
    description = "Clean matplotlib plots";
    homepage = "https://github.com/nschloe/dufte";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ris ];
  };
}
