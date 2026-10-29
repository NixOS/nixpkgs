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
    hash = "sha256-NY4k9fsKht5vFdUWh1OtTLuX5Ss2sb16u61AU6629iE=";
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
