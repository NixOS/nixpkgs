{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioairzone-cloud";
  version = "0.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = "aioairzone-cloud";
    tag = version;
    hash = "sha256-fWd5feCWE2o0HqvzGhGngWsIkXtS+VdZJ0d6B10Jq1E=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "aioairzone_cloud" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Library to control Airzone via Cloud API";
    homepage = "https://github.com/Noltari/aioairzone-cloud";
    changelog = "https://github.com/Noltari/aioairzone-cloud/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
