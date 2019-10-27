{ stdenv
, buildPythonPackage
, fetchPypi
, unittest2
, pyasn1
, mock
, isPy3k
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rsa";
  version = "4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a836406405730121ae9823e19c6e806c62bbad73f890574fff50efa4122c487";
  };

  checkInputs = [ unittest2 mock ];
  propagatedBuildInputs = [ pyasn1 ];

  preConfigure = stdenv.lib.optionalString (isPy3k && pythonOlder "3.7") ''
    substituteInPlace setup.py --replace "open('README.md')" "open('README.md',encoding='utf-8')"
  '';

  meta = with stdenv.lib; {
    homepage = https://stuvel.eu/rsa;
    license = licenses.asl20;
    description = "A pure-Python RSA implementation";
  };

}
