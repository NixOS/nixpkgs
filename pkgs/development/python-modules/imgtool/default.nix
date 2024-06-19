{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  cbor2,
  click,
  cryptography,
  intelhex,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "imgtool";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T3+831PETqqmImUEUQzLUvfvAMmXUDz5STSzMMlge2A=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cbor2
    click
    cryptography
    intelhex
    pyyaml
  ];

  pythonImportsCheck = [ "imgtool" ];

  meta = with lib; {
    description = "MCUboot's image signing and key management";
    mainProgram = "imgtool";
    homepage = "https://github.com/mcu-tools/mcuboot";
    license = licenses.asl20;
    maintainers = with maintainers; [ samueltardieu ];
  };
}
