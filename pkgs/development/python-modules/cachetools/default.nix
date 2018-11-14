{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cachetools";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90f1d559512fc073483fe573ef5ceb39bf6ad3d39edc98dc55178a2b2b176fa3";
  };

  meta = with stdenv.lib; {
    description = "Extensible memoizing collections and decorators";
    homepage = "https://github.com/tkem/cachetools";
    license = licenses.mit;
  };
}
