{ lib
, buildPythonPackage
, fetchPypi
, pbr
, docutils
, six
, chardet
, stevedore
, restructuredtext_lint
, pygments
}:

buildPythonPackage rec {
  pname = "doc8";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e967db31ea10699667dd07790f98cf9d612ee6864df162c64e4954a8e30f90d";
  };

  buildInputs = [ pbr ];
  propagatedBuildInputs = [
    docutils
    six
    chardet
    stevedore
    restructuredtext_lint
    pygments
  ];

  doCheck = false;

  meta = {
    description = "Style checker for Sphinx (or other) RST documentation";
    homepage = "https://launchpad.net/doc8";
    license = lib.licenses.asl20;
  };
}
