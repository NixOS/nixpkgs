{ lib, buildPythonPackage, fetchPypi
, httplib2, google_auth, google-auth-httplib2, six, uritemplate, oauth2client }:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "1.7.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mlx5dvkh6rjkvkd91flyhrmji2kw9rlr05n8n4wccv2np3sam9f";
  };

  # No tests included in archive
  doCheck = false;

  propagatedBuildInputs = [ httplib2 google_auth google-auth-httplib2 six uritemplate oauth2client ];

  meta = with lib; {
    description = "The core Python library for accessing Google APIs";
    homepage = https://github.com/google/google-api-python-client;
    license = licenses.asl20;
    maintainers = with maintainers; [ primeos ];
  };
}
