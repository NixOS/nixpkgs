{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioairzone-cloud";
  version = "0.4.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = "aioairzone-cloud";
    rev = "refs/tags/${version}";
    hash = "sha256-DIWRYGDdK/wq1TrPSo9I1oZv5jX4rY4z+u7CTwJtyts=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "aioairzone_cloud" ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Library to control Airzone via Cloud API";
    homepage = "https://github.com/Noltari/aioairzone-cloud";
    changelog = "https://github.com/Noltari/aioairzone-cloud/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
