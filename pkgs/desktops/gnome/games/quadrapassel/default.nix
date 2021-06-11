{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  gtk3,
  gnome,
  gdk-pixbuf,
  librsvg,
  gsound,
  libmanette,
  gettext,
  itstool,
  libxml2,
  clutter,
  clutter-gtk,
  wrapGAppsHook,
  meson,
  ninja,
  python3,
  vala,
  desktop-file-utils,
}:

stdenv.mkDerivation rec {
  pname = "quadrapassel";
  version = "40.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "1d59sxmmmhi611hvr5jmsm276j9w20hc5yq4rk0s4d3svadyap79";
  };

  nativeBuildInputs = [
    meson
    ninja
    python3
    vala
    desktop-file-utils
    pkg-config
    gnome.adwaita-icon-theme
    libxml2
    itstool
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gdk-pixbuf
    librsvg
    libmanette
    gsound
    clutter
    libxml2
    clutter-gtk
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    description = "Classic falling-block game, Tetris";
    homepage = "https://wiki.gnome.org/Apps/Quadrapassel";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
