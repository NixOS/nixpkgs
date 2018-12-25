{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, oauth2client
, gdata
, simplejson
, httplib2
, keyring
, six
, rsa
}:

buildPythonPackage rec {
  pname = "goobook";
  version = "3.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "139a98d646d5c5963670944d5cfcc1a107677ee11fa98329221bd600457fda6d";
  };

  propagatedBuildInputs = [ oauth2client gdata simplejson httplib2 keyring six rsa ];

  preConfigure = ''
    sed -i '/distribute/d' setup.py
  '';

  meta = with stdenv.lib; {
    description = "Search your google contacts from the command-line or mutt";
    homepage    = https://pypi.python.org/pypi/goobook;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ lovek323 hbunke ];
    platforms   = platforms.unix;
  };

}
