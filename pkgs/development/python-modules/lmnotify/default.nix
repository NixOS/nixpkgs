{ lib
, buildPythonPackage
, fetchPypi
, oauthlib
, requests
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "lmnotify";
  version = "0.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l0h4yab7ix8psf65iygc1wy5xwq3v2rwwjixvd8rwk46d2477dx";
  };

  propagatedBuildInputs = [ oauthlib requests requests_oauthlib ];

  doCheck = false; # no tests exist

  pythonImportsCheck = [ "lmnotify" ];

  meta = with lib; {
    description = "Python package for sending notifications to LaMetric Time";
    homepage = "https://github.com/keans/lmnotify";
    maintainers = with maintainers; [ rhoriguchi ];
    license = licenses.mit;
  };
}
