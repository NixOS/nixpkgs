{ lib
, buildPythonPackage
, fetchFromGitHub
, pymeeus
, pytz
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "convertdate";
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fitnr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iOHK3UJulXJJR50nhiVgfk3bt+CAtG3BRySJ8DkBuJE=";
  };

  propagatedBuildInputs = [
    pymeeus
    pytz
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "convertdate"
  ];

  meta = with lib; {
    description = "Utils for converting between date formats and calculating holidays";
    homepage = "https://github.com/fitnr/convertdate";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
