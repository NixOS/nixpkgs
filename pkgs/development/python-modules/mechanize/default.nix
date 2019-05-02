{ stdenv
, buildPythonPackage
, fetchPypi
, html5lib
, isPy3k
}:

buildPythonPackage rec {
  pname = "mechanize";
  version = "0.4.2";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b680ca1b4fabe5ef52024d120f40b8e2ed7d175ed4d67225d2c477dac7c7a58b";
  };

  propagatedBuildInputs = [ html5lib ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Stateful programmatic web browsing in Python";
    homepage = http://wwwsearch.sourceforge.net/;
    license = "BSD-style";
  };

}
