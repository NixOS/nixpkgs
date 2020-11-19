{ lib, fetchPypi, buildPythonPackage, docutils, six, sphinx, isPy3k, isPy27 }:

buildPythonPackage rec {
  version = "4.23.0";
  pname = "breathe";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c28e251ad8a42e4d3dd6c0861a66128b400131614b36f19df505ea34c934f801";
  };

  propagatedBuildInputs = [ docutils six sphinx ];

  doCheck = !isPy3k;

  meta = {
    homepage = "https://github.com/michaeljones/breathe";
    license = lib.licenses.bsd3;
    description = "Sphinx Doxygen renderer";
    inherit (sphinx.meta) platforms;
  };
}

