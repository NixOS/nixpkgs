{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pytzdata";
  version = "2019.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0469062f799c66480fcc7eae69a8270dc83f0e6522c0e70db882d6bd708d378";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Timezone database for Python";
    homepage = https://github.com/sdispater/pytzdata;
    license = licenses.mit;
  };
}
