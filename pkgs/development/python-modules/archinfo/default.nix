{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "archinfo";
  version = "9.2.15";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-K9EAyCvwgWhiZ+rkPKPGBr3lWYIIRCf0FAzPjIjrcU8=";
  };

  checkInputs = [
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
