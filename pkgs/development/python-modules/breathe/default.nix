{ lib, fetchPypi, buildPythonPackage, docutils, six, sphinx, isPy3k }:

buildPythonPackage rec {
  version = "4.13.0";
  pname = "breathe";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08xs1cqpvcv7735j19c35br34gbwzfn89rkg12n2yfz4af0x3xfp";
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

