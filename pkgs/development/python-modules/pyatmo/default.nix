{ lib
, buildPythonPackage
, fetchPypi
, oauthlib
, requests
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "pyatmo";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "148713395d51a57f1f3102eacbb9286a859fc5c18c066238a961a1acf189b930";
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
