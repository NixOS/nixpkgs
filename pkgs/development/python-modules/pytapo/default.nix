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

buildPythonPackage (finalAttrs: {
  pname = "pytapo";
  version = "3.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-GjySk9zHv1tWwjO5fq0YgoVg8YDPZdbbMByXRVIktJk=";
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
    changelog = "https://github.com/JurajNyiri/pytapo/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fleaz ];
  };
})
