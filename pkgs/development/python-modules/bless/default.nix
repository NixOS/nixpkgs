{ lib
, aioconsole
, bleak
, buildPythonPackage
, dbus-next
, fetchFromGitHub
, numpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bless";
  version = "0.2.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kevincar";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+rnMLqNfhIJASCKkIfOKpVil3S/d8BcMxnLHmdOcRIY=";
  };

  propagatedBuildInputs = [
    bleak
    dbus-next
  ];

  checkInputs = [
    aioconsole
    numpy
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "bless"
  ];

  meta = with lib; {
    description = "Library for creating a BLE Generic Attribute Profile (GATT) server";
    homepage = "https://github.com/kevincar/bless";
    changelog = "https://github.com/kevincar/bless/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
