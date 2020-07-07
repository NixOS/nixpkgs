{ stdenv
, mkDerivation
, fetchFromGitHub
, cmake
, dbus
, dde-qt-dbus-factory
, deepin-shortcut-viewer
, dtkwidget
, pkg-config
, qttools
, deepin
, wrapGAppsHook
}:

mkDerivation rec {
  pname = "dde-calendar";
  version = "5.7.0.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1f7n1w6czpp8v9nipbvaslz6qzmhwk9hkqsda24wppkh2x1n0j55";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    deepin.setupHook
    wrapGAppsHook
  ];

  buildInputs = [
    dbus
    dde-qt-dbus-factory
    deepin-shortcut-viewer
    dtkwidget
  ];

  postPatch = ''
    searchHardCodedPaths
    fixPath $out /usr CMakeLists.txt
    fixPath $out /usr/bin/dde-calendar assets/dbus/com.deepin.Calendar.service
    substituteInPlace assets/dde-calendar.desktop --replace Exec=dde-calendar Exec=$out/bin/dde-calendar
    substituteInPlace src/calendarmainwindow.cpp --replace \"deepin-shortcut-viewer\" \"${deepin-shortcut-viewer}/bin/deepin-shortcut-viewer\"
    substituteInPlace src/main.cpp --replace dbus-send ${dbus}/bin/dbus-send


    # Fixes from archlinux

    sed -i '/<QQueue>/a #include <QMouseEvent>' src/daymonthview.cpp
    sed -i '/<QStylePainter>/a #include <QMouseEvent>' src/schcedulesearchview.cpp
    sed -i '/include <QJsonObject>/a #include <QMouseEvent>' src/draginfographicsview.cpp

    # Not included in https://github.com/linuxdeepin/dde-calendar/pull/30 yet
    sed -i '/include <QPainter>/a #include <QPainterPath>' src/schcedulesearchview.cpp src/daymonthview.cpp src/weekheadview.cpp src/customframe.cpp
    sed -i '/include <QMessageBox>/a #include <QWheelEvent>' src/yearwindow.cpp
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
    description = "Calendar for Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/dde-calendar";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
