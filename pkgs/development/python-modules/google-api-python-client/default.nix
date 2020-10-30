{ lib, buildPythonPackage, fetchPypi
, google_auth, google-auth-httplib2, google_api_core
, httplib2, six, uritemplate, oauth2client }:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "1.12.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a989wynp0m1pj8qpa0mr8v8zxhazasc738nyb15wkhn1m4wv4hq";
  };

  # No tests included in archive
  doCheck = false;

  propagatedBuildInputs = [
    google_auth google-auth-httplib2 google_api_core
    httplib2 six uritemplate oauth2client
  ];

  meta = with lib; {
    description = "The official Python client library for Google's discovery based APIs";
    longDescription = ''
      These client libraries are officially supported by Google. However, the
      libraries are considered complete and are in maintenance mode. This means
      that we will address critical bugs and security issues but will not add
      any new features.
    '';
    homepage = "https://github.com/google/google-api-python-client";
    changelog = "https://github.com/googleapis/google-api-python-client/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ primeos ];
  };
}
