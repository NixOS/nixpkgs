{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, cbor2
, click
, cryptography
, intelhex
}:

buildPythonPackage rec {
  pname = "imgtool";
  version = "1.10.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A7NOdZNKw9lufEK2vK8Rzq9PRT98bybBfXJr0YMQS0A=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cbor2
    click
    cryptography
    intelhex
  ];

  pythonImportsCheck = [
    "imgtool"
  ];

  meta = with lib; {
    description = "MCUboot's image signing and key management";
    homepage = "https://github.com/mcu-tools/mcuboot";
    license = licenses.asl20;
    maintainers = with maintainers; [ samueltardieu ];
  };
}
