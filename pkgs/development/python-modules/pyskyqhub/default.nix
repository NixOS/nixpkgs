{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyskyqhub";
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RogerSelwyn";
    repo = "skyq_hub";
    tag = finalAttrs.version;
    hash = "sha256-yXqtABbsCh1yb96lsEA0gquikVenGLCo6J93AeXAC8k=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Tests require physical hardware
  doCheck = false;

  pythonImportsCheck = [ "pyskyqhub" ];

  meta = {
    description = "Python module for accessing SkyQ Hub";
    homepage = "https://github.com/RogerSelwyn/skyq_hub";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
