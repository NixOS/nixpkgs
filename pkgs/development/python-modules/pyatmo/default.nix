{ lib
, buildPythonPackage
, fetchPypi
, oauthlib
, requests
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "pyatmo";
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9949338833a27b6c3251b52bf70b73aa99c43c56153541338cb63001afafdd1e";
  };

  propagatedBuildInputs = [ oauthlib requests requests_oauthlib ];

  # Upstream provides no unit tests.
  doCheck = false;

  meta = with lib; {
    description = "Simple API to access Netatmo weather station data";
    license = licenses.mit;
    homepage = "https://github.com/jabesq/netatmo-api-python";
    maintainers = with maintainers; [ delroth ];
  };
}
