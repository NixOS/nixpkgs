{ lib, fetchPypi, buildPythonPackage, docutils, six, sphinx, isPy3k }:

buildPythonPackage rec {
  version = "4.9.1";
  pname = "breathe";

  src = fetchPypi {
    inherit pname version;
    sha256 = "76e1f3706efeda2610d9a8e7b421d2877ff0654a3fe6d3190a8686536111a684";
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

