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
  version = "3.3.38";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o3onR27lKg2QAa1Tgdidv6iOzqb/XlkJPq+vkkIhnAY=";
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

  meta = with lib; {
    description = "Python library for communication with Tapo Cameras";
    homepage = "https://github.com/JurajNyiri/pytapo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fleaz ];
  };
}
