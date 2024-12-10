{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  vala,
  gnome,
  gtk3,
  wrapGAppsHook3,
  appstream-glib,
  desktop-file-utils,
  glib,
  librsvg,
  libxml2,
  gettext,
  itstool,
  libgee,
  libgnome-games-support,
  meson,
  ninja,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "gnome-klotski";
  version = "3.38.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-klotski/${lib.versions.majorMinor version}/gnome-klotski-${version}.tar.xz";
    sha256 = "1qm01hdd5yp8chig62bj10912vclbdvywwczs84sfg4zci2phqwi";
  };

  nativeBuildInputs = [
    pkg-config
    vala
    meson
    ninja
    python3
    wrapGAppsHook3
    gettext
    itstool
    libxml2
    appstream-glib
    desktop-file-utils
    gnome.adwaita-icon-theme
  ];
  buildInputs = [
    glib
    gtk3
    librsvg
    libgee
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
    homepage = "https://gitlab.gnome.org/GNOME/gnome-klotski";
    description = "Slide blocks to solve the puzzle";
    mainProgram = "gnome-klotski";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
