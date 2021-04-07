{ lib
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
  version = "4.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9";
  };

  checkInputs = [ unittest2 mock ];
  propagatedBuildInputs = [ pyasn1 ];

  preConfigure = lib.optionalString (isPy3k && pythonOlder "3.7") ''
    substituteInPlace setup.py --replace "open('README.md')" "open('README.md',encoding='utf-8')"
  '';

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    homepage = "https://stuvel.eu/rsa";
    license = licenses.asl20;
    description = "A pure-Python RSA implementation";
  };

}
