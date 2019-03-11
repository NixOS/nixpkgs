{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pytzdata";
  version = "2018.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dddaaf4f1717820a6fdcac94057e03c1a15b3829a44d9eaf19988917977db408";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Timezone database for Python";
    homepage = https://github.com/sdispater/pytzdata;
    license = licenses.mit;
  };
}
