{ lib, fetchPypi, buildPythonPackage, docutils, six, sphinx, isPy3k }:

buildPythonPackage rec {
  version = "4.12.0";
  pname = "breathe";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wmxppzyvfd5gab72qi3gainibrdk4xi8nsfp5z5h49xgzi84mnq";
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

