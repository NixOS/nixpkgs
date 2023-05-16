{ lib
, buildPythonPackage
, fetchPypi
, google-auth
, google-auth-httplib2
, google-api-core
, httplib2
, uritemplate
, oauth2client
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-api-python-client";
<<<<<<< HEAD
  version = "2.97.0";
=======
  version = "2.84.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-SCdykYlIdqHKftQSfgVegfgeY0PO0bVEpyAK4sEZ3Nc=";
=======
    hash = "sha256-w5j9b56tC+I6reOycExyxRRt8OM1LY/5EBKGB34bAQo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    google-auth
    google-auth-httplib2
    google-api-core
    httplib2
    uritemplate
    oauth2client
    setuptools
  ];

  # No tests included in archive
  doCheck = false;

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
