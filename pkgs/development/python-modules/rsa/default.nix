{ stdenv
, buildPythonPackage
, fetchPypi
, unittest2
, pyasn1
, mock
, isPy3k
, pythonOlder
, poetry
}:

buildPythonPackage rec {
  pname = "rsa";
  version = "4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6fa6a54eb72bfc0abca7f27880b978b14a643ba2a6ad9f4a56a95be82129ca1b";
  };

  checkInputs = [ unittest2 mock ];
  propagatedBuildInputs = [ pyasn1 ];

  preConfigure = stdenv.lib.optionalString (isPy3k && pythonOlder "3.7") ''
    substituteInPlace setup.py --replace "open('README.md')" "open('README.md',encoding='utf-8')"
  '';

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://stuvel.eu/rsa";
    license = licenses.asl20;
    description = "A pure-Python RSA implementation";
  };

}
