{ stdenv
, buildPythonPackage
, fetchpatch
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

  patches = [
    # Fix compatibility for Python 3.7 https://github.com/DanielStutzbach/blist/pull/78
    (fetchpatch {
      url = "https://github.com/DanielStutzbach/blist/commit/2dc1ec28ed68611fcec9ac1c68070c782d6b4b4e.patch";
      sha256 = "0ma0z6ga80w3wzh3sidwd8ckfbgx4j1y7cc29q6j9ddrvxpf276y";
    })
  ];

  meta = with stdenv.lib; {
    homepage = http://stutzbachenterprises.com/blist/;
    description = "A list-like type with better asymptotic performance and similar performance on small lists";
    license = licenses.bsd0;
  };

}
