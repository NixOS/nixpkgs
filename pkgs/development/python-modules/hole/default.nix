{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hole";
  version = "0.9.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-hole";
    tag = version;
    hash = "sha256-yyqLbnW49R7f8C0IBL8z9Sq69TtaS5Ng2VQLJofNqcI=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "hole" ];

  meta = with lib; {
    description = "Python API for interacting with a Pihole instance";
    homepage = "https://github.com/home-assistant-ecosystem/python-hole";
    changelog = "https://github.com/home-assistant-ecosystem/python-hole/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
