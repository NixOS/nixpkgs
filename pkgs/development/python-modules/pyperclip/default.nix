{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.6.4";
  pname = "pyperclip";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f70e83d27c445795b6bf98c2bc826bbf2d0d63d4c7f83091c8064439042ba0dc";
  };

  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/asweigart/pyperclip;
    license = licenses.bsdOriginal;
    description = "Cross-platform clipboard module";
  };
}
