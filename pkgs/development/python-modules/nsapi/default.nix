{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytz,
}:

buildPythonPackage rec {
  pname = "nsapi";
  version = "3.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aquatix";
    repo = "ns-api";
    tag = "v${version}";
    hash = "sha256-Buhc0643WeX/4ZU/RkzNWiFjfEAJUtNL6uJ98unTnCg=";
  };

  build-system = [ setuptools ];

  dependencies = [ pytz ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ns_api" ];

  meta = with lib; {
    description = "Python module to query routes of the Dutch railways";
    homepage = "https://github.com/aquatix/ns-api/";
    changelog = "https://github.com/aquatix/ns-api/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
