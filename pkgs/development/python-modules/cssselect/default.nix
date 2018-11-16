{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cssselect";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "066d8bc5229af09617e24b3ca4d52f1f9092d9e061931f4184cd572885c23204";
  };

  # AttributeError: 'module' object has no attribute 'tests'
  doCheck = false;

  meta = with stdenv.lib; {
  };
}
