{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.8.0";
  pname = "pyperclip";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b75b975160428d84608c26edba2dec146e7799566aea42c1fe1b32e72b6028f2";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/asweigart/pyperclip";
    license = licenses.bsdOriginal;
    description = "Cross-platform clipboard module";
  };
}
