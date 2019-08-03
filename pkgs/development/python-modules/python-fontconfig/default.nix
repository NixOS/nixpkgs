{ lib, buildPythonPackage, fetchPypi, fontconfig, python, cython, freefont_ttf, makeFontsConf }:

let
  fontsConf = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };
in buildPythonPackage rec {
  pname = "Python-fontconfig";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "154rfd0ygcbj9y8m32n537b457yijpfx9dvmf76vi0rg4ikf7kxp";
  };

  buildInputs = [ fontconfig ];
  nativeBuildInputs = [ cython ];

  preBuild = ''
    ${python.interpreter} setup.py build_ext -i
  '';

  checkPhase = ''
    export FONTCONFIG_FILE=${fontsConf};
    echo y | ${python.interpreter} test/test.py
  '';

  meta = {
    homepage = https://github.com/Vayn/python-fontconfig;
    description = "Python binding for Fontconfig";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ gnidorah ];
  };
}
