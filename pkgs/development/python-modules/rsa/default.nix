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
  version = "4.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a7245638fa914ed6196b5e88fa5064cd95c7e65df800ec5d4f288e2b19fb4af";
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
