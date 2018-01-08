{ buildPythonPackage , fetchPypi , python , stdenv }:

buildPythonPackage rec {
  pname = "papis-python-rofi";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1izz0061p1xxyga3b9i4lgjd5yzjyaxa4qpff1ls9arixb90nr34";
  };

  meta = {
    homepage    = https://github.com/alejandrogallo/python-rofi;
    description = "Create simple GUIs using the Rofi application";
    license     = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}

