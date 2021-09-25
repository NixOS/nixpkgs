{ lib, buildPythonPackage, fetchPypi
, google-auth, google-auth-httplib2, google-api-core
, httplib2, six, uritemplate, oauth2client, setuptools }:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "2.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a25661ec6cf4c159f41fe9c061c2bee31b2dddaf2ad787e23617048a25b53842";
  };

  # No tests included in archive
  doCheck = false;

  propagatedBuildInputs = [
    google-auth google-auth-httplib2 google-api-core
    httplib2 six uritemplate oauth2client setuptools
  ];

  pythonImportsCheck = [
    "googleapiclient"
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
    maintainers = with maintainers; [ ];
  };
}
