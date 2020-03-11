{ lib, buildPythonPackage, fetchPypi
, httplib2, google_auth, google-auth-httplib2, six, uritemplate, oauth2client }:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "1.7.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02blmm32xfwjjcxds6ym9nnz29wzyiahd64shrsrkrdm6aqagmlz";
  };

  # No tests included in archive
  doCheck = false;

  propagatedBuildInputs = [ httplib2 google_auth google-auth-httplib2 six uritemplate oauth2client ];

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
