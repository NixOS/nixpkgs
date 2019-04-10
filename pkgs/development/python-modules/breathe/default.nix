{ lib, fetchPypi, buildPythonPackage, docutils, six, sphinx, isPy3k }:

buildPythonPackage rec {
  version = "4.11.1";
  pname = "breathe";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mps0cfli6iq2gqsv3d24fs1cp7sq7crd9ji6lw63b9r40998ylv";
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

