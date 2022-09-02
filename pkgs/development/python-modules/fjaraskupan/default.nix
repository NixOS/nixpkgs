{ lib
, bleak
, buildPythonPackage
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fjaraskupan";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "elupus";
    repo = pname;
    rev = version;
    hash = "sha256-ohadGQxtW8YcSDIF7xZhy84xu0Vi5yj/QEVi8WRRBSI=";
  };

  propagatedBuildInputs = [
    bleak
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "fjaraskupan"
  ];

  meta = with lib; {
    description = "Module for controlling Fjäråskupan kitchen fans";
    homepage = "https://github.com/elupus/fjaraskupan";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
