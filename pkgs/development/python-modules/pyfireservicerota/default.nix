{ lib
, buildPythonPackage
, fetchPypi
, pytz
, oauthlib
, requests
, websocket-client
}:

buildPythonPackage rec {
  pname = "pyfireservicerota";
  version = "0.0.43";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3+QK1BVuWYii0oYT4xXMOYJZmVKrB4EmqE0EkdFlZvE=";
  };

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
