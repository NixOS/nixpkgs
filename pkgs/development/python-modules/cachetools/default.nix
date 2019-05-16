{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cachetools";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9efcc9fab3b49ab833475702b55edd5ae07af1af7a4c627678980b45e459c460";
  };

  meta = with stdenv.lib; {
    description = "Extensible memoizing collections and decorators";
    homepage = "https://github.com/tkem/cachetools";
    license = licenses.mit;
  };
}
