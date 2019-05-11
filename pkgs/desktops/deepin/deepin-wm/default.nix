{ stdenv, fetchFromGitHub, pkgconfig, intltool, libtool, vala, gnome3,
  dbus, bamf, clutter-gtk, pantheon, libgee, libcanberra-gtk3,
  libwnck3, deepin-menu, deepin-mutter, deepin-wallpapers,
  deepin-desktop-schemas, wrapGAppsHook, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-wm";
  version = "1.9.38";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1qhdnv4x78f0gkr94q0j8x029fk9ji4m9jdipgrdm83pnahib80g";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    libtool
    vala
    gnome3.gnome-common
    wrapGAppsHook
    deepin.setupHook
  ];

  buildInputs = [
    bamf
    clutter-gtk
    dbus
    deepin-desktop-schemas
    deepin-menu
    deepin-mutter
    deepin-wallpapers
    gnome3.gnome-desktop
    libcanberra-gtk3
    libgee
    libwnck3
    pantheon.granite
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging

    # fix background path
    fixPath ${deepin-wallpapers} /usr/share/backgrounds src/Background/BackgroundSource.vala
    sed -i 's|default_background.jpg|deepin/desktop.jpg|' src/Background/BackgroundSource.vala

    # fix executable paths in desktop files
    sed -i -e "s,Exec=dbus-send,Exec=${dbus}/bin/dbus-send," data/gala-multitaskingview.desktop.in
    sed -i -e "s,Exec=deepin-wm,Exec=$out/bin/deepin-wm," data/gala.desktop
  '';

  NIX_CFLAGS_COMPILE = "-DWNCK_I_KNOW_THIS_IS_UNSTABLE";

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  postFixup = ''
    searchHardCodedPaths $out  # debugging
  '';

  enableParallelBuilding = true;

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Deepin Window Manager";
    homepage = https://github.com/linuxdeepin/deepin-wm;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
