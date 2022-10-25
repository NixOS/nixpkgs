{ buildPythonPackage, fetchPypi, nose, zope-interface }:

buildPythonPackage rec {
  pname = "lazr.delegates";
  version = "2.0.4";

  propagatedBuildInputs = [ nose zope-interface ];

  doCheck = false;  # cannot import name 'ClassType' from 'types'

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rdnl85j9ayp8n85l0ciip621j9dcziz5qnmv2m7krgwgcn31vfx";
  };
}
