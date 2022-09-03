{ lib
, aioconsole
, bleak
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bless";
  version = "0.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kevincar";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lC1M6/9uawi4KpcK4/fAygENa9rZv9c7qCVdsZYtl5Q=";
  };

  propagatedBuildInputs = [
    bleak
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
