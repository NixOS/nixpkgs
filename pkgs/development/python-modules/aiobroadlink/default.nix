{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiobroadlink";
  version = "0.1.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-3/IGp1gYfLNBkJuh8JJ/Wy73aJW61O0imM5w4HneZH0=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiobroadlink" ];

  meta = {
    description = "Python module to control various Broadlink devices";
    mainProgram = "aiobroadlink";
    homepage = "https://github.com/frawau/aiobroadlink";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
