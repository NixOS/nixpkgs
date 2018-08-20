{ stdenv, fetchFromGitHub, pkgconfig, intltool, libtool, vala, gnome3,
  bamf, clutter-gtk, pantheon, libcanberra-gtk3, libwnck3,
  deepin-mutter, deepin-wallpapers, deepin-desktop-schemas,
  hicolor-icon-theme, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-wm";
  version = "1.9.34";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "13hydcalifdc6723k8l4pk905y9sxic5x1fqww0fyx7j6b3hm13f";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    libtool
    gnome3.gnome-common
    vala
  ];

  buildInputs = [
    gnome3.gnome-desktop
    gnome3.libgee
    bamf
    clutter-gtk
    pantheon.granite
    libcanberra-gtk3
    libwnck3
    deepin-mutter
    deepin-wallpapers
    deepin-desktop-schemas
    hicolor-icon-theme
  ];

  postPatch = ''
    sed -i src/Background/BackgroundSource.vala \
      -e 's;/usr/share/backgrounds/default_background.jpg;${deepin-wallpapers}/share/backgrounds/deepin/desktop.jpg;'
  '';

  preConfigure = ''
    ./autogen.sh
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
