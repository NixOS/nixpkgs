{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, cmake, dde-qt-dbus-factory,
  dde-session-ui, deepin, deepin-desktop-schemas, deepin-wallpapers,
  dtkcore, dtkwidget, gsettings-qt, qtsvg, qttools, qtx11extras,
  which, xdg_utils, wrapGAppsHook, glib }:

mkDerivation rec {
  pname = "dde-launcher";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0zh6bb0r3pgjrnw9rba46ghdzza1ka1mv7r1znf8gw24wsjgjcpn";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    qttools
    wrapGAppsHook
    deepin.setupHook
  ];

  buildInputs = [
    dde-qt-dbus-factory
    dde-session-ui
    deepin-desktop-schemas
    deepin-wallpapers
    dtkcore
    dtkwidget
    glib
    gsettings-qt
    qtsvg
    qtx11extras
    which
    xdg_utils
  ];

  postPatch = ''
    # debugging
    searchHardCodedPaths

    substituteInPlace CMakeLists.txt --replace "/usr/share" "$out/share"

    substituteInPlace src/dbusservices/com.deepin.dde.Launcher.service --replace "/usr" "$out"

    substituteInPlace src/historywidget.cpp --replace "xdg-open" "${xdg_utils}/bin/xdg-open"
    substituteInPlace src/widgets/miniframebottombar.cpp --replace "dde-shutdown" "${dde-session-ui}/bin/dde-shutdown"
    substituteInPlace src/widgets/miniframerightbar.cpp --replace "which" "${which}/bin/which"

    # Uncomment (and remove space after $) after packaging deepin-manual
    #substituteInPlace src/sharedeventfilter.cpp --replace "dman" "$ {deepin-manual}/bin/dman"

    for f in src/boxframe/*.cpp; do
      substituteInPlace $f --replace "/usr/share/backgrounds/default_background.jpg" "${deepin-wallpapers}/share/backgrounds/deepin/desktop.jpg"
    done

    # note: `dbus-send` path does not need to be hard coded because it is not used for dtkcore >= 2.0.8.0
  '';

  dontWrapQtApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
    )
  '';

  postFixup = ''
    # debugging
    searchHardCodedPaths $out
  '';

  passthru.updateScript = deepin.updateScript { name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Deepin Desktop Environment launcher module";
    homepage = https://github.com/linuxdeepin/dde-launcher;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
