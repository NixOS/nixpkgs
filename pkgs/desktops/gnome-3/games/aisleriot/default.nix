{ lib, stdenv
, fetchFromGitLab
, pkg-config
, gnome3
, itstool
, gtk3
, wrapGAppsHook
, meson
, librsvg
, libxml2
, desktop-file-utils
, pysolfc
, guile
, libcanberra-gtk3
, ninja
, appstream-glib
, yelp-tools
}:

stdenv.mkDerivation rec {
  pname = "aisleriot";
  version = "3.22.9";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = version;
    sha256 = "1rsh41mhcrp3k23lqsnyc5yyfp184ks5p2idkwjyxry547mddyrk";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    meson
    ninja
    appstream-glib
    pkg-config
    itstool
    libxml2
    desktop-file-utils
    yelp-tools
  ];

  buildInputs = [
    gtk3
    librsvg
    guile
    libcanberra-gtk3
    pysolfc
  ];

  prePatch = ''
    patchShebangs cards/meson_svgz.sh
    patchShebangs data/meson_desktopfile.py
    patchShebangs data/icons/meson_updateiconcache.py
    patchShebangs src/lib/meson_compileschemas.py
  '';

  mesonFlags = [
    "-Dtheme_kde=false"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Aisleriot";
    description = "A collection of patience games written in guile scheme";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
