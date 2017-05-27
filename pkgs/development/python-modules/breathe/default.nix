{ lib, fetchurl, buildPythonPackage, docutils, six, sphinx, isPy3k }:

buildPythonPackage rec {
  version = "4.2.0";
  pname = "breathe";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/b/breathe/${name}.tar.gz";
    sha256 = "0m3w8yx24nm01xxx6aj08cklnifwlzzmczc5b0ni40l63lhvm3lp";
  };

  propagatedBuildInputs = [ docutils six sphinx ];

  disabled = isPy3k;

  meta = {
    homepage = https://github.com/michaeljones/breathe;
    license = lib.licenses.bsd3;
    description = "Sphinx Doxygen renderer";
    inherit (sphinx.meta) platforms;
  };
}

