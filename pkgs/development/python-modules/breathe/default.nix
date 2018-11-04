{ lib, fetchPypi, buildPythonPackage, docutils, six, sphinx, isPy3k }:

buildPythonPackage rec {
  version = "4.11.0";
  pname = "breathe";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca91bbee1b0040cc4566b6d3be055e7ddf232efcb62f728165c0c7ac77c6a317";
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

