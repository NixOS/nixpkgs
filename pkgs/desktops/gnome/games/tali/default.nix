{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk3,
  gnome,
  gdk-pixbuf,
  librsvg,
  libgnome-games-support,
  gettext,
  itstool,
  libxml2,
  wrapGAppsHook,
  meson,
  ninja,
  python3,
  desktop-file-utils,
}:

stdenv.mkDerivation rec {
  pname = "tali";
  version = "40.1";

  src = fetchurl {
    url = "mirror://gnome/sources/tali/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "1xhp30c70bi8p4sm6v8zmxi1p55fs56dqgfbhfnsda5g1cxwir7h";
  };

  nativeBuildInputs = [
    meson
    ninja
    python3
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
    libgnome-games-support
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Tali";
    description = "Sort of poker with dice and less money";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
