{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, gsound, gettext, itstool, libxml2
, meson, ninja, vala, python3, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "gnome-taquin";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-taquin/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "07xpvyks1r5wxvjz1n07g7khxa02smhq4kykc4d22fmzr3yka077";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-taquin"; attrPath = "gnome3.gnome-taquin"; };
  };

  nativeBuildInputs = [
    pkgconfig wrapGAppsHook meson ninja python3
    gettext itstool libxml2 vala desktop-file-utils
  ];
  buildInputs = [
    gtk3 librsvg gsound
    gnome3.adwaita-icon-theme
  ];

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Taquin";
    description = "Move tiles so that they reach their places";
    maintainers = teams.gnome.members;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
