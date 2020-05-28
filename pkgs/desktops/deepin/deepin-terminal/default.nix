{ stdenv
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, at-spi2-core
, dde-qt-dbus-factory
, deepin-shortcut-viewer
, dtkcore
, dtkwidget
, expect
, lxqt
, qtbase
, qttools
, deepin
, wrapGAppsHook
}:

mkDerivation rec {
  pname = "deepin-terminal";
  version = "5.2.22";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-terminal";
    rev = version;
    sha256 = "17ljkb3a03yh9gkhzy9rd4ajf6k5wh507wj1cxlgaakbv01qhx3n";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    lxqt.lxqt-build-tools
    deepin.setupHook
    wrapGAppsHook
  ];

  buildInputs = [
    at-spi2-core
    dde-qt-dbus-factory
    deepin-shortcut-viewer
    dtkcore
    expect
    qtbase
  ];

  propagatedBuildInputs = [
    dtkwidget
  ];

  cmakeFlags = [
    # to be able to find dtk-settings-tools
    "-DDTKCORE_TOOL_DIR=${dtkcore}/lib/libdtk-${dtkcore.version}/DCore/bin"
  ];

  postPatch = ''
    searchHardCodedPaths

    fixPath $out /usr 3rdparty/terminalwidget/CMakeLists.txt

    fixPath $out /usr/bin/deepin-terminal 3rdparty/terminalwidget/lib/Pty.cpp

    fixPath ${expect} /usr/bin/expect src/assets/other/ssh_login.sh

    substituteInPlace src/deepin-terminal.desktop --replace "Exec=deepin-terminal" "Exec=$out/bin/deepin-terminal"

    substituteInPlace src/main/mainwindow.cpp --replace "deepin-shortcut-viewer" "${deepin-shortcut-viewer}/bin/deepin-shortcut-viewer"

    substituteInPlace src/views/termwidget.cpp --replace "/bin/bash" "${stdenv.shell}"

    # from archlinux
    sed -i '/LXQtCompilerSettings/a remove_definitions(-DQT_NO_CAST_FROM_ASCII -DQT_NO_CAST_TO_ASCII)' 3rdparty/terminalwidget/CMakeLists.txt
    sed -i 's|default-config.json|src/assets/other/default-config.json|' CMakeLists.txt

    # avoid error:
    # file cannot create directory: /homeless-shelter/.config/deepin/deepin-terminal
    export HOME=$TMP
  '';

  dontWrapQtApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
    )
  '';

  postFixup = ''
    searchHardCodedPaths $out
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Default terminal emulator for Deepin";
    longDescription = ''
      Deepin terminal, it sharpens your focus in the world of command line!
      It is an advanced terminal emulator with workspace, multiple
      windows, remote management, quake mode and other features.
    '';
    homepage = "https://github.com/linuxdeepin/deepin-terminal";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
