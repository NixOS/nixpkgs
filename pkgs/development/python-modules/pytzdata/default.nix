{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pytzdata";
  version = "2019.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fac06f7cdfa903188dc4848c655e4adaee67ee0f2fe08e7daf815cf2a761ee5e";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Timezone database for Python";
    homepage = https://github.com/sdispater/pytzdata;
    license = licenses.mit;
  };
}
