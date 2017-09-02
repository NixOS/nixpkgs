{ lib, fetchurl, buildPythonPackage, docutils, six, sphinx, isPy3k }:

buildPythonPackage rec {
  version = "4.7.2";
  pname = "breathe";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/b/breathe/${name}.tar.gz";
    sha256 = "dd15efc66d65180e4c994edd15fcb642812ad04ac9c36738b28bf248d7c0be32";
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

