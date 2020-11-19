{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.8.1";
  pname = "pyperclip";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9abef1e79ce635eb62309ecae02dfb5a3eb952fa7d6dce09c1aef063f81424d3";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/asweigart/pyperclip";
    license = licenses.bsdOriginal;
    description = "Cross-platform clipboard module";
  };
}
