{ lib, fetchPypi, buildPythonPackage, docutils, six, sphinx, isPy3k }:

buildPythonPackage rec {
  version = "4.13.1";
  pname = "breathe";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6752345252f48092bf72a450fd9e84367bd5b4af99d86c92047f82c6c2287ab";
  };

  propagatedBuildInputs = [ docutils six sphinx ];

  doCheck = !isPy3k;

  meta = {
    homepage = https://github.com/michaeljones/breathe;
    license = lib.licenses.bsd3;
    description = "Sphinx Doxygen renderer";
    inherit (sphinx.meta) platforms;
  };
}

