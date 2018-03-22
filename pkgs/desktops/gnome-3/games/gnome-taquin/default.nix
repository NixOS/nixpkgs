{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libcanberra-gtk3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-taquin-${version}";
  version = "3.26.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-taquin/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "de352bb2dfcd759de37f6bccf1e4790760e020b4bb06a1bc8d5f03d89613b6fd";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-taquin"; attrPath = "gnome3.gnome-taquin"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook librsvg libcanberra-gtk3
    intltool itstool libxml2 gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Taquin;
    description = "Move tiles so that they reach their places";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
