{ lib
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
  version = "4.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-44RkpJxshdfxNRsBJmYUh6fgoUpQ8WdexQ6zTU8g7yE=";
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
