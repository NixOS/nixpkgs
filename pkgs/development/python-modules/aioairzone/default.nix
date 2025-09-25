{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioairzone";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = "aioairzone";
    tag = version;
    hash = "sha256-pFbX92UxhNcbHjU1Leoyr225Q6lCHT3hfv/mLSm7y2c=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioairzone" ];

  meta = with lib; {
    description = "Module to control AirZone devices";
    homepage = "https://github.com/Noltari/aioairzone";
    changelog = "https://github.com/Noltari/aioairzone/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
