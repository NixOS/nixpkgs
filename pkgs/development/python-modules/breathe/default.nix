{ lib, fetchPypi, buildPythonPackage, docutils, six, sphinx, isPy3k, isPy27 }:

buildPythonPackage rec {
  version = "4.28.0";
  pname = "breathe";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "11e35a5fed7545554be51b70eea4578643d8c08972bea43774f413943006b17a";
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

