{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  cython,
  setuptools,

  # dependencies
  fontconfig,
  freefont_ttf,
  makeFontsConf,

  # testing
  dejavu_fonts,
  python,
}:

let
  fontsConf = makeFontsConf { fontDirectories = [ freefont_ttf ]; };
in
buildPythonPackage rec {
  pname = "python-fontconfig";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_fontconfig";
    inherit version;
    sha256 = "sha256-1esVZVMvkcAKWchaOrIki2CYoJDffN1PW+A9nXWjCeU=";
  };

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [ fontconfig ];

  preBuild = ''
    ${python.pythonOnBuildForHost.interpreter} setup.py build_ext -i
  '';

  nativeCheckInputs = [ dejavu_fonts ];

  preCheck = ''
    export FONTCONFIG_FILE=${fontsConf};
    export HOME=$TMPDIR
  '';

  checkPhase = ''
    runHook preCheck
    echo y | ${python.interpreter} test/test.py
    runHook postCheck
  '';

  meta = {
    homepage = "https://github.com/Vayn/python-fontconfig";
    description = "Python binding for Fontconfig";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
