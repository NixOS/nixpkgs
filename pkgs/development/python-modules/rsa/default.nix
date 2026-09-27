{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pyasn1,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rsa";
  version = "4.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-572/21SX2kwH39NVMOGpAmWdtv8kHjnZlTytBuvQrnU=";
  };

  build-system = [ poetry-core ];
  dependencies = [ pyasn1 ];

  # PyPi package does not include tests.
  doCheck = false;

  meta = {
    homepage = "https://stuvel.eu/rsa";
    license = lib.licenses.asl20;
    description = "Pure-Python RSA implementation";
  };
}
