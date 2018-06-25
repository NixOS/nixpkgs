{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.6.2";
  pname = "pyperclip";

  src = fetchPypi {
    inherit pname version;
    sha256 = "43496f0a1f363a5ecfc4cda5eba6a2a3d5056fe6c7ffb9a99fbb1c5a3c7dea05";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/asweigart/pyperclip";
    license = licenses.bsdOriginal;
    description = "Cross-platform clipboard module";
  };
}
