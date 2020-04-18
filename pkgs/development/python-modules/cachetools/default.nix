{ stdenv, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "cachetools";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9a52dd97a85f257f4e4127f15818e71a0c7899f121b34591fcc1173ea79a0198";
  };

  meta = with stdenv.lib; {
    description = "Extensible memoizing collections and decorators";
    homepage = "https://github.com/tkem/cachetools";
    license = licenses.mit;
  };
}
