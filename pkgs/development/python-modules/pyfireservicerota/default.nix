{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  pdm-backend,
  pytz,
  oauthlib,
  requests,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "pyfireservicerota";
  version = "0.0.44";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OknGX4xP+AHXRuhizbeTVAfiOX0uRGzAly7FJ1vopDI=";
  };

  postPatch = ''
    # https://github.com/cyberjunky/python-fireservicerota/pull/1
    substituteInPlace pyproject.toml \
      --replace-fail '"aiohttp",' '"requests",' \
      --replace-fail '"aiohttp_retry",' ""
  '';

  nativeBuildInputs = [ pdm-backend ];

  propagatedBuildInputs = [
    pytz
    oauthlib
    requests
    websocket-client
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pyfireservicerota" ];

  meta = with lib; {
    description = "Python 3 API wrapper for FireServiceRota/BrandweerRooster";
    homepage = "https://github.com/cyberjunky/python-fireservicerota";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
