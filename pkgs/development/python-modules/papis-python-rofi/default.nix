{ buildPythonPackage, lib, fetchPypi }:

buildPythonPackage rec {
  pname = "papis-python-rofi";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13k6mw2nq923zazs77hpmh2s96v6zv13g7p89510qqkvp6fiml1v";
  };

  # No tests existing
  doCheck = false;

  meta = {
    description = "A Python module to make simple GUIs with Rofi";
    homepage = "https://github.com/alejandrogallo/python-rofi";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
