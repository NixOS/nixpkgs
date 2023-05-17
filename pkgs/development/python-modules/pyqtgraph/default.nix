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
, fetchpatch
}:

let
  fontsConf = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };
in
buildPythonPackage rec {
  pname = "pyqtgraph";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "pyqtgraph";
    repo = "pyqtgraph";
    rev = "pyqtgraph-${version}";
    sha256 = "093kkxwj75nb508vz7px4x7lxrwpaff10pl15m4h74hjwyvbsg3d";
  };

  # TODO: remove when updating to 0.12.3
  patches = [
    (fetchpatch {
      url = "https://github.com/pyqtgraph/pyqtgraph/commit/2de5cd78da92b48e48255be2f41ae332cf8bb675.patch";
      sha256 = "1hy86psqyl6ipvbg23zvackkd6f7ajs6qll0mbs0x2zmrj92hk00";
    })
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
