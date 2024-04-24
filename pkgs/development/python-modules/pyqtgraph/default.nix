{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, scipy
, numpy
, pyqt5
, pyopengl
, qt5
, pytestCheckHook
, freefont_ttf
, makeFontsConf
, setuptools
}:

let
  fontsConf = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };
in
buildPythonPackage rec {
  pname = "pyqtgraph";
  version = "0.13.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pyqtgraph";
    repo = "pyqtgraph";
    rev = "refs/tags/pyqtgraph-${version}";
    hash = "sha256-KVgsfvaVbR3eMRNqhJSBO4Hfk7KJgMdsZjKffx6vt84=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
    pyqt5
    scipy
    pyopengl
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export QT_PLUGIN_PATH="${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM=offscreen
    export DYLD_FRAMEWORK_PATH=/System/Library/Frameworks
    export FONTCONFIG_FILE=${fontsConf}
  '';

  pytestFlagsArray = [
    # we only want to run unittests
    "tests"
  ];

  disabledTests = lib.optionals (!stdenv.hostPlatform.isx86) [
    # small precision-related differences on other architectures,
    # upstream doesn't consider it serious.
    # https://github.com/pyqtgraph/pyqtgraph/issues/2110
    "test_PolyLineROI"
  ] ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
    # https://github.com/pyqtgraph/pyqtgraph/issues/2645
    "test_rescaleData"
  ];

  meta = with lib; {
    description = "Scientific Graphics and GUI Library for Python";
    homepage = "https://www.pyqtgraph.org/";
    changelog = "https://github.com/pyqtgraph/pyqtgraph/blob/master/CHANGELOG";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ koral ];
  };

}
