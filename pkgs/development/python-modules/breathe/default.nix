{ lib, fetchPypi, buildPythonPackage, docutils, six, sphinx, isPy3k, isPy27 }:

buildPythonPackage rec {
  version = "4.24.0";
  pname = "breathe";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "cd959f259361473896857d5720386963800f8401d29b696705ebb01711d96e35";
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

