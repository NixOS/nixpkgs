{
  lib,
  buildPythonPackage,
  fetchPypi,
  pycryptodome,
  python-kasa,
  pythonOlder,
  requests,
  rtp,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "pytapo";
  version = "3.3.48";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2MBolLmcInRO1EMYsV0cV4AsvS9cJATDiP5iBjPkrk0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pycryptodome
    python-kasa
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
