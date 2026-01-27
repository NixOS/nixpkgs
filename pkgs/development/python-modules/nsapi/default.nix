{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nsapi";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aquatix";
    repo = "ns-api";
    tag = "v${version}";
    hash = "sha256-eZT6DU68wcEYyoFejECuluzit9MDA269zaKVFWpSuc8=";
  };

  build-system = [ setuptools ];

  dependencies = [ pytz ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ns_api" ];

  meta = {
    description = "Python module to query routes of the Dutch railways";
    homepage = "https://github.com/aquatix/ns-api/";
    changelog = "https://github.com/aquatix/ns-api/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
