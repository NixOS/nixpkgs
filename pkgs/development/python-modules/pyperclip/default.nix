{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.8.2";
  pname = "pyperclip";

  src = fetchPypi {
    inherit pname version;
    sha256 = "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/asweigart/pyperclip";
    license = licenses.bsdOriginal;
    description = "Cross-platform clipboard module";
  };
}
