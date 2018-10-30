{ stdenv
, buildPythonPackage
, fetchPypi
, isPyPy
}:

buildPythonPackage rec {
  pname = "blist";
  version = "1.3.6";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hqz9pqbwx0czvq9bjdqjqh5bwfksva1is0anfazig81n18c84is";
  };

  meta = with stdenv.lib; {
    homepage = http://stutzbachenterprises.com/blist/;
    description = "A list-like type with better asymptotic performance and similar performance on small lists";
    license = licenses.bsd0;
  };

}
