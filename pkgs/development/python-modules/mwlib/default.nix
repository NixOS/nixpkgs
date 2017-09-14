{ stdenv, buildPythonPackage, fetchurl, fetchPypi, isPy3k, apipkg, bottle, gevent
, lxml, pillow, py, pyPdf, qserve, roman, simplejson, sqlite3dbm, timelib, pytest }:

let
  pyparsing = buildPythonPackage rec {
    pname = "pyparsing";
    version = "1.5.7";
    name  = "${pname}-${version}";
    disabled = isPy3k;

    src = fetchPypi {
      inherit pname version;
      sha256 = "17z7ws076z977sclj628fvwrp8y9j2rvdjcsq42v129n1gwi8vk4";
    };
    meta = with stdenv.lib; {
      homepage = http://pyparsing.wikispaces.com/;
      description = "An alternative approach to creating and executing simple grammars, vs. the traditional lex/yacc approach, or the use of regular expressions";
    };
  };
  odfpy = buildPythonPackage rec {
    pname = "odfpy";
    version = "0.9.6";
    disabled = isPy3k;
    name  = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "14880cb34kidqhr4svp374dwcsk5mmlzwi8asxvyvmycy5lzjn74";
    };
    doCheck = false;
    meta = with stdenv.lib; {
      description = "Python API and tools to manipulate OpenDocument files";
      homepage = "https://joinup.ec.europa.eu/software/odfpy/home";
      license = lib.licenses.asl20;
    };
  };
in buildPythonPackage rec {
  pname = "mwlib";
  version = "0.15.15";
  name  = "${pname}-${version}";
  disabled = isPy3k;

  src = fetchurl {
    url = "http://pypi.pediapress.com/packages/mirror/${name}.tar.gz";
    sha256 = "1dnmnkc21zdfaypskbpvkwl0wpkpn0nagj1fc338w64mbxrk8ny7";
  };


  propagatedBuildInputs = [
      apipkg
      bottle
      gevent
      lxml
      odfpy
      pillow
      py
      pyPdf
      pyparsing
      qserve
      roman
      simplejson
      sqlite3dbm
      timelib
  ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  # Tests are in build directory but we need extension modules that are in $out
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Library for parsing MediaWiki articles and converting them to different output formats";
    homepage = "http://pediapress.com/code/";
    license = licenses.bsd3;
  };
}
