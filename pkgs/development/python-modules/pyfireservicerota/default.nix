{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  pytz,
  oauthlib,
  requests,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "pyfireservicerota";
  version = "0.0.49";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "python-fireservicerota";
    tag = version;
    hash = "sha256-EVMxAOP6haS+jkLD6pOZnu0yhhNMR+gCud2qXsycNbc=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    pytz
    oauthlib
    requests
    websocket-client
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pyfireservicerota" ];

  meta = {
    changelog = "https://github.com/cyberjunky/python-fireservicerota/releases/tag/${src.tag}";
    description = "Python 3 API wrapper for FireServiceRota/BrandweerRooster";
    homepage = "https://github.com/cyberjunky/python-fireservicerota";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
