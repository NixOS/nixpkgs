{ lib, buildPythonPackage, fetchPypi, fetchpatch
, google_auth, google-auth-httplib2, google_api_core
, httplib2, six, uritemplate, oauth2client }:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14d7719sxl7bqpw3k4hhfwd0l0v98lnpi7qlhdaf8jxw21ivzmpz";
  };

  patches = [
    # To fix a regression/bug in 1.8.1:
    (fetchpatch {
      url = "https://github.com/googleapis/google-api-python-client/commit/1d8ec6874e1c6081893de7cd7cbc86d1f6580320.patch";
      sha256 = "1nr24jzvbkzaigv9c935fkpzfa36hj6k7yx5bdwxqfhpa3p9i8n9";
    })
  ];

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
