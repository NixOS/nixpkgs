{ lib
, stdenv
, fetchurl
, fetchpatch
, pkg-config
, gnome
, gtk3
, wrapGAppsHook
, librsvg
, gsound
, clutter-gtk
, gettext
, itstool
, vala
, python3
, libxml2
, libgee
, libgnome-games-support
, meson
, ninja
, desktop-file-utils
, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "gnome-nibbles";
  version = "3.38.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-nibbles/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1naknfbciydbym79a0jq039xf0033z8gyln48c0qsbcfr2qn8yj5";
  };

  patches = [
    # Fix build with recent Vala.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-nibbles/-/commit/62964e9256fcac616109af874dbb2bd8342a9853.patch";
      sha256 = "4VijELRxycS8rwi1HU9U3h9K/VtdQjJntfdtMN9Uz34=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-nibbles/-/commit/1b48446068608aff9b5edf1fdbd4b8c0d9f0be94.patch";
      sha256 = "X0+Go5ae4F06WTPDYc2HIIax8X4RDgUGO6A6Qp8UifQ=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    vala
    python3
    pkg-config
    wrapGAppsHook
    gettext
    itstool
    libxml2
    desktop-file-utils
    hicolor-icon-theme
  ];

  buildInputs = [
    gtk3
    librsvg
    gsound
    clutter-gtk
    gnome.adwaita-icon-theme
    libgee
    libgnome-games-support
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-nibbles";
      attrPath = "gnome.gnome-nibbles";
    };
  };

  meta = with lib; {
    description = "Guide a worm around a maze";
    homepage = "https://wiki.gnome.org/Apps/Nibbles";
    license = licenses.gpl2;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
