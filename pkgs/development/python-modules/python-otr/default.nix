{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, zope_interface
, cryptography
, application
, gmpy2
}:

buildPythonPackage rec {
  pname = "python-otr";
  version = "1.2.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qKJcphUgJ0M1gMAHZNzkTsSzvHSBjPvQWBt5clNEH2k=";
  };

  propagatedBuildInputs = [ zope_interface cryptography application gmpy2 ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A pure python implementation of OTR";
    homepage = https://github.com/AGProjects/otr;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ edwtjo ];
  };

}
