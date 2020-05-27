{ stdenv
, mkDerivation
, fetchFromGitHub
, pkg-config
, cmake
, dbus
, deepin
, deepin-shortcut-viewer
, dtkwidget
, kcodecs
, qttools
, syntax-highlighting
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "deepin-editor";
  version = "5.6.28";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1cvflsg56m3m699ihd3bkw4g5bcr8cky4ffyqv1f5vrmvgqw51zx";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
    deepin.setupHook
  ];

  buildInputs = [
    dbus
    deepin-shortcut-viewer
    dtkwidget
    kcodecs
    syntax-highlighting
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging

    patchShebangs translate_generation.sh

    fixPath $out /usr \
      CMakeLists.txt \
      dedit/main.cpp \
      src/resources/settings.json \
      src/thememodule/themelistmodel.cpp \
      src/window.cpp

    substituteInPlace deepin-editor.desktop \
      --replace "Exec=deepin-editor" "Exec=$out/bin/deepin-editor"

    substituteInPlace src/editwrapper.cpp \
      --replace "appExec = \"deepin-editor\"" "appExec = \"$out/bin/deepin-editor\""

    substituteInPlace src/dtextedit.cpp --replace dbus-send              ${dbus}/bin/dbus-send
    substituteInPlace src/window.cpp    --replace dbus-send              ${dbus}/bin/dbus-send
    substituteInPlace src/window.cpp    --replace deepin-shortcut-viewer ${deepin-shortcut-viewer}/bin/deepin-shortcut-viewer
  '';

  postFixup = ''
    searchHardCodedPaths -a $out  # debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Simple editor for Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/deepin-editor";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo worldofpeace ];
  };
}
