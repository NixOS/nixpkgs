{ lib, buildPythonPackage, fetchPypi, fontconfig, python, freefont_ttf }:

buildPythonPackage rec {
  pname = "Python-fontconfig";
  version = "0.5.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "154rfd0ygcbj9y8m32n537b457yijpfx9dvmf76vi0rg4ikf7kxp";
  };

  propagatedBuildInputs = [ fontconfig ];

  buildInputs = [ freefont_ttf ];

  checkPhase = "echo y | ${python.interpreter} test/test.py";

  meta = {
    homepage = https://github.com/Vayn/python-fontconfig;
    description = "Python binding for Fontconfig";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ gnidorah ];
  };
}
