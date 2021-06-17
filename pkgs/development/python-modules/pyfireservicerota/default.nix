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
  version = "0.0.40";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d8173f6682ef2a61367660a15559c8c7a7e00db3f98092e0fa52e771df356f4";
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
