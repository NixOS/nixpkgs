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
  version = "4.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c6bd9dc7a543b7fe4304a631f8a8a3b674e2bbfc49c2ae96200cdbe55df6b17";
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
