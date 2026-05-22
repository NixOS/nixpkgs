{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-fullykiosk";
  version = "0.0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cgarwood";
    repo = "python-fullykiosk";
    tag = version;
    hash = "sha256-t/o4yRIh/r6cocEJ7c9oOa/C7RE3ZltkpzsCKS/dJHY=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "fullykiosk" ];

  meta = {
    description = "Wrapper for Fully Kiosk Browser REST interface";
    homepage = "https://github.com/cgarwood/python-fullykiosk";
    changelog = "https://github.com/cgarwood/python-fullykiosk/releases/tag/${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
