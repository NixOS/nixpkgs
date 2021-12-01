{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, apipkg
, bottle
, gevent
, lxml
, odfpy
, pillow
, py
, pyPdf
, pyparsing
, qserve
, roman
, simplejson
, sqlite3dbm
, timelib
, pytest
}:

buildPythonPackage rec {
  version = "0.16.1";
  pname = "mwlib";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dnmnkc21zdfaypskbpvkwl0wpkpn0nagj1fc338w64mbxrk8ny7";
  };

  propagatedBuildInputs = [ apipkg bottle gevent lxml odfpy pillow py pyPdf pyparsing qserve roman simplejson sqlite3dbm timelib ];

  checkInputs = [ pytest ];

  postPatch = ''
    sed -i "s/odfpy>=0.9, <0.10/odfpy/" setup.py
    sed -i "s/pyparsing>=1.4.11,<1.6/pyparsing/" setup.py
  '';

  checkPhase = ''
    py.test
  '';

  # Tests are in build directory but we need extension modules that are in $out
  doCheck = false;

  meta = with lib; {
    description = "Library for parsing MediaWiki articles and converting them to different output formats";
    homepage = "http://pediapress.com/code/";
    license = licenses.bsd3;
    # broken = true; # Requires different versions of packages
  };

}
