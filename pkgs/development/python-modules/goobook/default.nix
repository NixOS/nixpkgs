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
  version = "1.9";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "02xmq8sjavza17av44ks510934wrshxnsm6lvhvazs45s92b671i";
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
