{ lib, fetchurl, buildPythonPackage, docutils, six, sphinx, isPy3k }:

buildPythonPackage rec {
  version = "4.6.0";
  pname = "breathe";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/b/breathe/${name}.tar.gz";
    sha256 = "9db2ba770f824da323b9ea3db0b98d613a4e0af094c82ccb0a82991da81b736a";
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

