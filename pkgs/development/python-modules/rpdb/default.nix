{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "rpdb";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-g0bw3UmKHDB2ivPTUozf6AhtjAV8n8y1Qwta7DKuFqs=";
  };

  build-system = [
    poetry-core
  ];

  meta = {
    description = "PDB wrapper with remote access via TCP socket";
    homepage = "https://github.com/tamentis/rpdb";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
