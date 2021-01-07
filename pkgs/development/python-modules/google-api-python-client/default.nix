{ lib, buildPythonPackage, fetchPypi
, google-auth, google-auth-httplib2, google-api-core
, httplib2, six, uritemplate, oauth2client }:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "1.12.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f3b9684442eec2cfe9f9bb48e796ef919456b82142c7528c5fd527e5224f08bb";
  };

  # No tests included in archive
  doCheck = false;

  propagatedBuildInputs = [
    google-auth google-auth-httplib2 google-api-core
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
