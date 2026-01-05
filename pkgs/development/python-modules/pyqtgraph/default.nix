{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  scipy,
  numpy,
  pyopengl,

  # buildInputs
  pyqt6,

  # tests
  qt6,
  pytestCheckHook,
  freefont_ttf,
  makeFontsConf,
}:

let
  fontsConf = makeFontsConf { fontDirectories = [ freefont_ttf ]; };
in
buildPythonPackage rec {
  pname = "pyqtgraph";
  version = "0.13.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyqtgraph";
    repo = "pyqtgraph";
    tag = "pyqtgraph-${version}";
    hash = "sha256-MUwg1v6oH2TGmJ14Hp9i6KYierJbzPggK59QaHSXHVA=";
  };

  patches = [
    # Fixes a segmentation fault in tests with Qt 6.10. See:
    # https://github.com/pyqtgraph/pyqtgraph/issues/3390
    # The patch is the merge commit of:
    # https://github.com/pyqtgraph/pyqtgraph/pull/3370
    (fetchpatch {
      url = "https://github.com/pyqtgraph/pyqtgraph/commit/bf38b8527e778c9c0bb653bc0df7bb36018dcbae.patch";
      hash = "sha256-Tv4QK/OZvmDO3MOjswjch7DpF96U1uRN0dr8NIQ7+LY=";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
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

  enabledTestPaths = [
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
    changelog = "https://github.com/pyqtgraph/pyqtgraph/blob/${src.tag}/CHANGELOG";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      koral
      doronbehar
    ];
  };
}
