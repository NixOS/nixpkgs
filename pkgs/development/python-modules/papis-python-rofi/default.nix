{
  buildPythonPackage,
  lib,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "papis-python-rofi";
  version = "1.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "358e24f5fb0a86de6f15d5168753ad4cbb97e52b36b1bd7abbad4053aeb6f621";
  };

  # No tests existing
  doCheck = false;

  meta = {
    description = "Python module to make simple GUIs with Rofi";
    homepage = "https://github.com/alejandrogallo/python-rofi";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
