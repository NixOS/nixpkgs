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
  version = "4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yl1svkr4skn3qb571s0p6pss9xnv2w09sbgy6dqbpa4cykab7hh";
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
