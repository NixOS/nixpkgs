{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, tokenize-rt
}:

buildPythonPackage rec {
  pname = "pyupgrade";
  version = "2.23.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Z17Bs3Mr1PJ9bYP2vsXTaJ85jOoIIlKLWR6D6s7enFs=";
  };

  checkInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [ tokenize-rt ];

  pythonImportsCheck = [ "pyupgrade" ];

  meta = with lib; {
    description = "Tool to automatically upgrade syntax for newer versions of the language";
    homepage = "https://github.com/asottile/pyupgrade";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
