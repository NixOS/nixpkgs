{
  buildPythonPackage,
  cython,
  fetchPypi,
  fetchpatch,
  fontconfig,
  freefont_ttf,
  lib,
  makeFontsConf,
  python,
}:

let
  fontsConf = makeFontsConf { fontDirectories = [ freefont_ttf ]; };
in
buildPythonPackage rec {
  pname = "python-fontconfig";
  version = "0.5.1";

  src = fetchPypi {
    pname = "Python-fontconfig";
    inherit version;
    sha256 = "154rfd0ygcbj9y8m32n537b457yijpfx9dvmf76vi0rg4ikf7kxp";
  };

  buildInputs = [ fontconfig ];
  nativeBuildInputs = [ cython ];

  patches = [
    # distutils has been removed since python 3.12
    # See https://github.com/vayn/python-fontconfig/pull/10
    (fetchpatch {
      name = "no-distutils.patch";
      url = "https://github.com/vayn/python-fontconfig/commit/15e1a72c90e93a665569e0ba771ae53c7c8020c8.patch";
      hash = "sha256-2mAemltWh3+LV4FDOg6uSD09zok3Eyd+v1WJJdouOV8=";
    })
  ];

  preBuild = ''
    ${python.pythonOnBuildForHost.interpreter} setup.py build_ext -i
  '';

  checkPhase = ''
    export FONTCONFIG_FILE=${fontsConf};
    echo y | ${python.interpreter} test/test.py
  '';

  meta = {
    homepage = "https://github.com/Vayn/python-fontconfig";
    description = "Python binding for Fontconfig";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ];
  };
}
