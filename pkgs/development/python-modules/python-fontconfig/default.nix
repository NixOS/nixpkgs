{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = "python-fontconfig";
    tag = "v${version}";
    hash = "sha256-4qxl5a9oKmhrF8O2OjA8X1wsHyEHL4ViRt20IcU/ANw=";
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
  '';

  checkPhase = ''
    runHook preCheck
    echo y | ${python.interpreter} test/test.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "fontconfig" ];

  meta = {
    homepage = "https://github.com/Vayn/python-fontconfig";
    description = "Python binding for Fontconfig";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
