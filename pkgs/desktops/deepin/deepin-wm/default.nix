{ stdenv, fetchFromGitHub, pkgconfig, intltool, libtool, vala, gnome3,
  bamf, clutter-gtk, pantheon, libgee, libcanberra-gtk3, libwnck3,
  deepin-menu, deepin-mutter, deepin-wallpapers,
  deepin-desktop-schemas, wrapGAppsHook, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-wm";
  version = "1.9.37";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1xd2x0kyav2cxnk0bybl7lrmak1r2468slxz5a6anrdriw9l10gi";
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
    searchHardCodedPaths
    fixPath ${deepin-wallpapers} /usr/share/backgrounds src/Background/BackgroundSource.vala
    # fix background path
    sed -i 's|default_background.jpg|deepin/desktop.jpg|' src/Background/BackgroundSource.vala
  '';

  NIX_CFLAGS_COMPILE = "-DWNCK_I_KNOW_THIS_IS_UNSTABLE";

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
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
