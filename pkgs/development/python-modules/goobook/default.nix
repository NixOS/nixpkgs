{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, google_api_python_client, simplejson, oauth2client
}:

buildPythonPackage rec {
  pname = "goobook";
  version = "3.3";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sanlki1rcqvhbds7a049v2kzglgpm761i728115mdracw0s6i3h";
  };

  propagatedBuildInputs = [ google_api_python_client simplejson oauth2client ];

  meta = with stdenv.lib; {
    description = "Search your google contacts from the command-line or mutt";
    homepage    = https://pypi.python.org/pypi/goobook;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ primeos ];
    platforms   = platforms.unix;
  };
}
