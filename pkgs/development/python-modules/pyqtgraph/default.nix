{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  scipy,
  numpy,
  pyqt6,
  pyopengl,
  qt6,
  pytestCheckHook,
  freefont_ttf,
  makeFontsConf,
  setuptools,
}:

let
  fontsConf = makeFontsConf { fontDirectories = [ freefont_ttf ]; };
in
buildPythonPackage rec {
  pname = "pyqtgraph";
  version = "0.13.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pyqtgraph";
    repo = "pyqtgraph";
    rev = "refs/tags/pyqtgraph-${version}";
    hash = "sha256-MUwg1v6oH2TGmJ14Hp9i6KYierJbzPggK59QaHSXHVA=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    numpy
    scipy
    pyopengl
  ];
  buildInputs = [
    # Not propagating it so that every consumer of this package will be able to
    # use any of the upstream supported Qt Library, See:
    # https://pyqtgraph.readthedocs.io/en/pyqtgraph-0.13.7/getting_started/how_to_use.html#pyqt-and-pyside
    pyqt6
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export QT_PLUGIN_PATH="${lib.getBin qt6.qtbase}/${qt6.qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM=offscreen
    export DYLD_FRAMEWORK_PATH=/System/Library/Frameworks
    export FONTCONFIG_FILE=${fontsConf}
  '';

  pytestFlagsArray = [
    # we only want to run unittests
    "tests"
  ];

  disabledTests =
    lib.optionals (!stdenv.hostPlatform.isx86) [
      # small precision-related differences on other architectures,
      # upstream doesn't consider it serious.
      # https://github.com/pyqtgraph/pyqtgraph/issues/2110
      "test_PolyLineROI"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # https://github.com/pyqtgraph/pyqtgraph/issues/2645
      "test_rescaleData"
    ];

  meta = {
    description = "Scientific Graphics and GUI Library for Python";
    homepage = "https://www.pyqtgraph.org/";
    changelog = "https://github.com/pyqtgraph/pyqtgraph/blob/master/CHANGELOG";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ koral doronbehar ];
  };
}
