{ lib, fetchPypi, buildPythonPackage, docutils, six, sphinx, isPy3k }:

buildPythonPackage rec {
  version = "4.14.0";
  pname = "breathe";

  src = fetchPypi {
    inherit pname version;
    sha256 = "027arbjy0mzv13fbs3qf4qdl3cxzragkf07hc0n8rbwg13j4i20p";
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

