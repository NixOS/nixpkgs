{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "2.0.0";
  format = "setuptools";
  pname = "roman";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-kOg7UStE3X/IPWfrRapetwffYj5vxuZufyc6vUsmE64=";
  };

  meta = with lib; {
    description = "Integer to Roman numerals converter";
    homepage = "https://pypi.python.org/pypi/roman";
    license = licenses.psfl;
  };
}
