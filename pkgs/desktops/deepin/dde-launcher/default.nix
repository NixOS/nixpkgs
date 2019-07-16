{ stdenv, fetchFromGitHub, pkgconfig, cmake, dde-qt-dbus-factory,
  dde-session-ui, deepin, deepin-desktop-schemas, deepin-wallpapers,
  dtkcore, dtkwidget, gsettings-qt, qtsvg, qttools, qtx11extras,
  which, xdg_utils, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dde-launcher";
  version = "4.6.13";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1lwwn2qjbd4i7wx18mi8n7hzdh832i3kdadrivr10sbafdank7ky";
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

  postFixup = ''
    # debugging
    searchHardCodedPaths $out
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Deepin Desktop Environment launcher module";
    homepage = https://github.com/linuxdeepin/dde-launcher;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
