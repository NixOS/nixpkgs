{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-ctags3";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a2cb0b35f0d67bab47045d803dce8291a1500af11832b154f69b3785f2130daa";
  };

  meta = with lib; {
    description = "Ctags indexing python bindings";
    homepage = "https://github.com/jonashaag/python-ctags3";
    license = licenses.lgpl3Plus;
  };
}
