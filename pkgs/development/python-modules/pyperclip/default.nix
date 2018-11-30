{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.6.5";
  pname = "pyperclip";

  src = fetchPypi {
    inherit pname version;
    sha256 = "406bc020d4b8e60d8673876271b815befc4c02fd8d919e4aacc667d69fab99ea";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/asweigart/pyperclip";
    license = licenses.bsdOriginal;
    description = "Cross-platform clipboard module";
  };
}
