{ lib, buildPythonPackage, fetchPypi, isPy3k
, httplib2, google_auth, google-auth-httplib2, six, uritemplate, oauth2client }:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "1.7.8";
  #disabled = !isPy3k; # TODO: Python 2.7 was deprecated but weboob still depends on it.

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n18frf0ghmwf5lxmkyski4b5h1rsx93ibq3iw0k3s2wxl371406";
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
