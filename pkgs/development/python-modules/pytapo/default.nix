{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pycryptodome,
  requests,
  rtp,
  urllib3,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytapo";
  version = "3.3.37";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-InDbfWzRb+Q+E6feeatHIliq83g83oUfo3Yze/BAJdM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pycryptodome
    requests
    rtp
    urllib3
  ];

  pythonImportsCheck = [ "pytapo" ];

  # Tests require actual hardware
  doCheck = false;

  meta = {
    description = "Python library for communication with Tapo Cameras";
    homepage = "https://github.com/JurajNyiri/pytapo";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fleaz ];
  };
}
