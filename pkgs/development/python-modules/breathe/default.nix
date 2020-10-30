{ lib, fetchPypi, buildPythonPackage, docutils, six, sphinx, isPy3k, isPy27 }:

buildPythonPackage rec {
  version = "4.22.1";
  pname = "breathe";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e4b66e61876dac90e78b335788a38eaa3625ed9c70d0add261f98ddd128d36a";
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

