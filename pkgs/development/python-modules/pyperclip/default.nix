{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.6.0";
  pname = "pyperclip";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce829433a9af640e08ee89b20f7c62132714bcc5d77df114044d0fccb8c3b3b8";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/asweigart/pyperclip";
    license = licenses.bsdOriginal;
    description = "Cross-platform clipboard module";
  };
}
