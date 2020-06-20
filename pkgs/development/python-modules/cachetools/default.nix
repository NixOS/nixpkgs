{ stdenv, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "cachetools";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d057645db16ca7fe1f3bd953558897603d6f0b9c51ed9d11eb4d071ec4e2aab";
  };

  meta = with stdenv.lib; {
    description = "Extensible memoizing collections and decorators";
    homepage = "https://github.com/tkem/cachetools";
    license = licenses.mit;
  };
}
