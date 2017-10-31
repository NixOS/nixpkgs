{ lib, fetchurl, buildPythonPackage, docutils, six, sphinx, isPy3k }:

buildPythonPackage rec {
  version = "4.7.3";
  pname = "breathe";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/b/breathe/${name}.tar.gz";
    sha256 = "d0b0e029daba6c3889d15d6c2dd4b0e9d468dc631d41021d0576c1b0dabee302";
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

