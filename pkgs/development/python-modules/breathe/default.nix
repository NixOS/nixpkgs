{ lib, fetchPypi, buildPythonPackage, docutils, six, sphinx, isPy3k }:

buildPythonPackage rec {
  version = "4.11.0";
  pname = "breathe";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05x3qrvsriy0cn0p4bxnzhp27pvxbq2vxlxncr2wqh003gpbp4fa";
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

