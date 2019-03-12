{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libcanberra-gtk3, gettext, itstool, libxml2
, meson, ninja, vala, python3, desktop-file-utils
}:

stdenv.mkDerivation rec {
  name = "gnome-taquin-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-taquin/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1kyxh68gg7clxg22ls4sliisxb2sydwccbxqgfvxjg2fklr6r1lm";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-taquin"; attrPath = "gnome3.gnome-taquin"; };
  };

  nativeBuildInputs = [
    pkgconfig wrapGAppsHook meson ninja python3
    gettext itstool libxml2 vala desktop-file-utils
  ];
  buildInputs = [
    gtk3 librsvg libcanberra-gtk3
    gnome3.adwaita-icon-theme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Taquin;
    description = "Move tiles so that they reach their places";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
