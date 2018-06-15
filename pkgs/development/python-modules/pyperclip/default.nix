{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.6.1";
  pname = "pyperclip";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03ce3e66e2a26a085f0e043236dedd78aaabf53a64dab9a216671f74ee272845";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/asweigart/pyperclip";
    license = licenses.bsdOriginal;
    description = "Cross-platform clipboard module";
  };
}
