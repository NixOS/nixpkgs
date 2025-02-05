{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pdm-backend,
  pytz,
  oauthlib,
  requests,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "pyfireservicerota";
  version = "0.0.45";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "python-fireservicerota";
    tag = version;
    hash = "sha256-lQkn/DlqJMLxQlh1sn+v7d6xHHCC9r8mnUJchyTTUqA=";
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

  meta = with lib; {
    changelog = "https://github.com/cyberjunky/python-fireservicerota/releases/tag/${src.tag}";
    description = "Python 3 API wrapper for FireServiceRota/BrandweerRooster";
    homepage = "https://github.com/cyberjunky/python-fireservicerota";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
