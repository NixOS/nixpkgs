{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  fetchFromGitHub,
=======
  fetchPypi,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = "python-fontconfig";
    tag = "v${version}";
    hash = "sha256-4qxl5a9oKmhrF8O2OjA8X1wsHyEHL4ViRt20IcU/ANw=";
=======
  version = "0.6.1";
  pyproject = true;

  src = fetchPypi {
    pname = "python_fontconfig";
    inherit version;
    sha256 = "sha256-qka4KksXW9LPn+Grmyng3kyrhwIEG7UEpVDeKfX89zM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
    export HOME=$TMPDIR
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  checkPhase = ''
    runHook preCheck
    echo y | ${python.interpreter} test/test.py
    runHook postCheck
  '';

<<<<<<< HEAD
  pythonImportsCheck = [ "fontconfig" ];

  meta = {
    homepage = "https://github.com/Vayn/python-fontconfig";
    description = "Python binding for Fontconfig";
    license = lib.licenses.gpl3Plus;
=======
  meta = {
    homepage = "https://github.com/Vayn/python-fontconfig";
    description = "Python binding for Fontconfig";
    license = lib.licenses.gpl3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
