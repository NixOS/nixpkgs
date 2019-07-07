{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.7.0";
  pname = "pyperclip";

  src = fetchPypi {
    inherit pname version;
    sha256 = "979325468ccf682104d5dcaf753f869868100631301d3e72f47babdea5700d1c";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/asweigart/pyperclip";
    license = licenses.bsdOriginal;
    description = "Cross-platform clipboard module";
  };
}
