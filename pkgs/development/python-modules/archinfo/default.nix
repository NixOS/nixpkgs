{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, nose
, pythonOlder
}:

buildPythonPackage rec {
  pname = "archinfo";
  version = "9.2.7";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sl5qCH/biH3QBrnfZAQMWd55yKM0PGE/Rx2MscKn4Nk=";
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
