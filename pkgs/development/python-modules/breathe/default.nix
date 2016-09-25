{ lib, fetchurl, buildPythonPackage, docutils, six, sphinx, isPy3k }:

buildPythonPackage rec {
  name = "breathe-${version}";
  version = "4.2.0";

  src = fetchurl {
    url = "mirror://pypi/b/breathe/${name}.tar.gz";
    md5 = "e35f6ce54485663857129370047f6057";
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

