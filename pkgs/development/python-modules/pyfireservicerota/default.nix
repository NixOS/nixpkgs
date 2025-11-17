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
  version = "0.0.47";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "python-fireservicerota";
    tag = version;
    hash = "sha256-2pCv/9VwGUDS5wFdJCxOevl7vWg+iXInI/xY3jPp7BM=";
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
