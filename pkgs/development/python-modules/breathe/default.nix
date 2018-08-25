{ lib, fetchPypi, buildPythonPackage, docutils, six, sphinx, isPy3k }:

buildPythonPackage rec {
  version = "4.10.0";
  pname = "breathe";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e94370b8b607a32d9611ed8246e635f02c21dc6847f04e888a00f66a12694eff";
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

