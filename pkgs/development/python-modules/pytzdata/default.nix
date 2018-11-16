{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pytzdata";
  version = "2018.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e4ef42e82b0b493c5849eed98b5ab49d6767caf982127e9a33167f1153b36cc5";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Timezone database for Python";
    homepage = https://github.com/sdispater/pytzdata;
    license = licenses.mit;
  };
}
