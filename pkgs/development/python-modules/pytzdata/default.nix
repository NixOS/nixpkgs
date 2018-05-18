{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pytzdata";
  version = "2018.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e2cceb54335cd6c28caea46b15cd592e2aec5e8b05b0241cbccfb1b23c02ae7";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Timezone database for Python";
    homepage = https://github.com/sdispater/pytzdata;
    license = licenses.mit;
  };
}
