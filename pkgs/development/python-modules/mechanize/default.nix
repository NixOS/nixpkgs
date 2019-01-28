{ stdenv
, buildPythonPackage
, fetchPypi
, html5lib
, isPy3k
}:

buildPythonPackage rec {
  pname = "mechanize";
  version = "0.4.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "15g58z3hy1pgi5sygpif28jyqj79iz4vw2mh5nxdydl4w20micvf";
  };

  propagatedBuildInputs = [ html5lib ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Stateful programmatic web browsing in Python";
    homepage = http://wwwsearch.sourceforge.net/;
    license = "BSD-style";
  };

}
