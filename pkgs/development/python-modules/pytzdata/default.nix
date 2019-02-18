{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pytzdata";
  version = "2018.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10c74b0cfc51a9269031f86ecd11096c9c6a141f5bb15a3b8a88f9979f6361e2";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Timezone database for Python";
    homepage = https://github.com/sdispater/pytzdata;
    license = licenses.mit;
  };
}
