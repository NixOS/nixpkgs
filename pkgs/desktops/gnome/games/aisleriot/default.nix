{ stdenv
, lib
, fetchFromGitLab
, nix-update-script
, pkg-config
, itstool
, gtk3
, wrapGAppsHook
, meson
, librsvg
, libxml2
, desktop-file-utils
, guile_3_0
, libcanberra-gtk3
, ninja
, appstream-glib
, yelp-tools
}:

stdenv.mkDerivation rec {
  pname = "aisleriot";
  version = "3.22.21";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = version;
    sha256 = "sha256-dpzuePxSoJcwUlj314r5G9A8aF1Yz49r+DxNTfA8/Ks=";
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
    guile_3_0
    libcanberra-gtk3
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
    updateScript = nix-update-script {
      attrPath = "gnome.${pname}";
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
