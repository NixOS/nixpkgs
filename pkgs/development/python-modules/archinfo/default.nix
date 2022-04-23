{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, nose
, pythonOlder
}:

buildPythonPackage rec {
  pname = "archinfo";
  version = "9.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RWdY7tzT5wDVjAn1QIkQm8b5lIo++VzktsYZxn8taeg=";
  };

  checkInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "archinfo"
  ];

  meta = with lib; {
    description = "Classes with architecture-specific information";
    homepage = "https://github.com/angr/archinfo";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
