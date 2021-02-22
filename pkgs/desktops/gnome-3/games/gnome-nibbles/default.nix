{ lib, stdenv, fetchurl, pkg-config, gnome3, gtk3, wrapGAppsHook
, librsvg, gsound, clutter-gtk, gettext, itstool, vala, python3
, libxml2, libgee, libgnome-games-support, meson, ninja
, desktop-file-utils, hicolor-icon-theme}:

stdenv.mkDerivation rec {
  pname = "gnome-nibbles";
  version = "3.38.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-nibbles/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1naknfbciydbym79a0jq039xf0033z8gyln48c0qsbcfr2qn8yj5";
  };

  nativeBuildInputs = [
    meson ninja vala python3
    pkg-config wrapGAppsHook gettext itstool libxml2
    desktop-file-utils hicolor-icon-theme
  ];
  buildInputs = [
    gtk3 librsvg gsound clutter-gtk gnome3.adwaita-icon-theme
    libgee libgnome-games-support
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-nibbles";
      attrPath = "gnome3.gnome-nibbles";
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
