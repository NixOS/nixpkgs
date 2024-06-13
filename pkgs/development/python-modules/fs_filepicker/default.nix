{ lib
, buildPythonPackage
, fetchFromGitHub
, fs
, future
, humanfriendly
, mock
, pyqt5
, pytestCheckHook
, pythonRelaxDepsHook
, qt5
}:

buildPythonPackage rec {
  pname = "fs_filepicker";
  version = "0.3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Open-MSS";
    repo = pname;
    rev = version;
    hash = "sha256-p4Uxl+kVSNUBlfclceArfLTsJxyxHTze1FhzH2CKXvI=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    qt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    fs
    future
    humanfriendly
    pyqt5
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonRelaxDeps = [
    "future"
  ];

  prePatch = ''
    # Necessary to avoid a segmentation fault in the test suite
    substituteInPlace tests/test_fs_filepicker.py \
      --replace 'self.application = QtWidgets.QApplication([])' 'self.application = QtWidgets.QApplication.instance() or QtWidgets.QApplication([])'
  '';

  # Properly wrap the pyqt application
  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp "$out/bin/fs_filepicker"
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
    export QT_PLUGIN_PATH="${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM_PLUGIN_PATH="${qt5.qtbase.bin}/lib/qt-${qt5.qtbase.version}/plugins";
    export QT_QPA_PLATFORM=offscreen
  '';

  meta = with lib; {
    homepage = "https://github.com/Open-MSS/fs_filepicker";
    description = "QT file picker (Open|Save|GetDirectory) for accessing a pyfilesystem2";
    license = licenses.asl20;
    maintainers = with maintainers; [ matrss ];
  };
}
