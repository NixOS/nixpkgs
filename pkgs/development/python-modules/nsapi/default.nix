{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nsapi";
  version = "3.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aquatix";
    repo = "ns-api";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-H8qxqzcGZ52W/HbTuKdnfnaYdZFaxzuUhrniS1zsL2w=";
  };

  build-system = [ setuptools ];

  dependencies = [ pytz ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ns_api" ];

  meta = with lib; {
    description = "Python module to query routes of the Dutch railways";
    homepage = "https://github.com/aquatix/ns-api/";
    changelog = "https://github.com/aquatix/ns-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
