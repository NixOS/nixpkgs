{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pytzdata";
  version = "2020.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h0md0ldhb8ghlwjslkzh3wcj4fxg3n43bj5sghqs2m06nri7yiy";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Timezone database for Python";
    homepage = "https://github.com/sdispater/pytzdata";
    license = licenses.mit;
  };
}
