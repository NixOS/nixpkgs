{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, tokenize-rt
}:

buildPythonPackage rec {
  pname = "pyupgrade";
  version = "2.38.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dSCo6qB7ON0V2BZoVVaV3X2VMgrjBwZ18wiiDj/+U94=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    tokenize-rt
  ];

  pythonImportsCheck = [
    "pyupgrade"
  ];

  meta = with lib; {
    description = "Tool to automatically upgrade syntax for newer versions of the language";
    homepage = "https://github.com/asottile/pyupgrade";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
