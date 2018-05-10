{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-ctags3";
  version = "1.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "62e1d48a8cd88756767f3f5e3f1b1a81bc84deeb736f0c9480a5b5d066f63c3e";
  };

  meta = with lib; {
    description = "Ctags indexing python bindings";
    homepage = https://github.com/jonashaag/python-ctags3;
    license = licenses.lgpl3Plus;
  };
}
