{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioairzone";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = "aioairzone";
    tag = version;
    hash = "sha256-eNSsBlLn6Go+2gQ8IHEzFOQPRuJM8nLqwIaDvXLgthY=";
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
