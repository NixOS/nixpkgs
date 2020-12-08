{ lib, fetchPypi, buildPythonPackage, docutils, six, sphinx, isPy3k, isPy27 }:

buildPythonPackage rec {
  version = "4.24.1";
  pname = "breathe";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d8e47ba4b975f3228a13daf481762f784f87d1e6e87a01619360d59e558d2fc0";
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

