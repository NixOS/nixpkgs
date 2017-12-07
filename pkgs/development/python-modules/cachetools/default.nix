{ stdenv, buildPythonPackage, fetchPypi, isPyPy }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "cachetools";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pdw2fr29pxlyn1g5fhdrrqbpn0iw062nv716ngdqvdx7hnizq7d";
  };

  meta = with stdenv.lib; {
    description = "Extensible memoizing collections and decorators";
    homepage = "https://github.com/tkem/cachetools";
    license = licenses.mit;
  };
}
