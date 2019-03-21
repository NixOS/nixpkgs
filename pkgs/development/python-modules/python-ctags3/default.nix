{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-ctags3";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "69029185ec70db4180be2b58e9a7245700c7ddcdc9049bf0641448f439112176";
  };

  meta = with lib; {
    description = "Ctags indexing python bindings";
    homepage = https://github.com/jonashaag/python-ctags3;
    license = licenses.lgpl3Plus;
  };
}
