{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, google_api_python_client, simplejson, oauth2client, setuptools
}:

buildPythonPackage rec {
  pname = "goobook";
  version = "3.4";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "089a95s6g9izsy1fzpz48p6pz0wpngcbbrvsillm1n53492gfhjg";
  };

  # Required for a breaking change in google-api-python-client 1.8.1:
  patches = [ ./fix-build.patch ];

  propagatedBuildInputs = [
    google_api_python_client simplejson oauth2client setuptools
  ];

  meta = with stdenv.lib; {
    description = "Search your google contacts from the command-line or mutt";
    homepage    = "https://pypi.python.org/pypi/goobook";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ primeos ];
    platforms   = platforms.unix;
  };
}
