{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pytzdata";
  version = "2020.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3efa13b335a00a8de1d345ae41ec78dd11c9f8807f522d39850f2dd828681540";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Timezone database for Python";
    homepage = "https://github.com/sdispater/pytzdata";
    license = licenses.mit;
  };
}
