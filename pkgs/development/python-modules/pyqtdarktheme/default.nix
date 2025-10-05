{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  darkdetect,
  poetry-core,

  pyqt5,
  pytest-mock,
  pytest-qt,
  pytestCheckHook,
  qt5,
}:

buildPythonPackage rec {
  pname = "pyqtdarktheme";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "5yutan5";
    repo = "PyQtDarkTheme";
    rev = "v${version}";
    hash = "sha256-jK+wnIyPE8Bav0pzbvVisYYCzdRshYw1S2t0H3Pro5M=";
  };

  patches = [ ./add-missing-argument-to-the-proxy-style-initializer.patch ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ darkdetect ];

  nativeCheckInputs = [
    pyqt5
    pytest-mock
    pytest-qt
    pytestCheckHook
  ];

  pythonImportsCheck = [ "qdarktheme" ];

  prePatch = ''
    sed -i 's#darkdetect = ".*"#darkdetect = "*"#' pyproject.toml
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
    export QT_PLUGIN_PATH="${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM_PLUGIN_PATH="${qt5.qtbase.bin}/lib/qt-${qt5.qtbase.version}/plugins";
    export QT_QPA_PLATFORM=offscreen
  '';

  meta = with lib; {
    description = "Flat dark theme for PySide and PyQt";
    homepage = "https://pyqtdarktheme.readthedocs.io/en/stable";
    license = licenses.mit;
    maintainers = [ ];
  };
}
