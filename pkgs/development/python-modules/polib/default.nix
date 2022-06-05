{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "polib";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e02c355ae5e054912e3b0d16febc56510eff7e49d60bf22aecb463bd2f2a2dfa";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with lib; {
    description = "A library to manipulate gettext files (po and mo files)";
    homepage = "https://bitbucket.org/izi/polib/";
    license = licenses.mit;
  };
}
