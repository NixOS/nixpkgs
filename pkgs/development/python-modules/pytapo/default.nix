{
  lib,
  buildPythonPackage,
  fetchPypi,
  pycryptodome,
  python-kasa,
  requests,
  rtp,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "pytapo";
  version = "3.3.56";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Cx3X0C8CiTixEdepj0bQViSMQJ65bVTRrZuMnPO/ys8=";
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
    changelog = "https://github.com/JurajNyiri/pytapo/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fleaz ];
  };
}
