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
  version = "3.3.44";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2/Wzc54a7LpphmH5qDp0M9SnmuCVGXCmhkoy4YSAZc0=";
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

  meta = with lib; {
    description = "Python library for communication with Tapo Cameras";
    homepage = "https://github.com/JurajNyiri/pytapo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fleaz ];
  };
}
