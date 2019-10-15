{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cachetools";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ea2d3ce97850f31e4a08b0e2b5e6c34997d7216a9d2c98e0f3978630d4da69a";
  };

  meta = with stdenv.lib; {
    description = "Extensible memoizing collections and decorators";
    homepage = "https://github.com/tkem/cachetools";
    license = licenses.mit;
  };
}
