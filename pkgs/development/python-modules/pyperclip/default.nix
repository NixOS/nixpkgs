{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.5.27";
  pname = "pyperclip";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1i9zxm7qc49n9yxfb41c0jbmmp2hpzx98kaizjl7qmgiv3snvjx3";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/asweigart/pyperclip";
    license = licenses.bsdOriginal;
    description = "Cross-platform clipboard module";
  };
}
