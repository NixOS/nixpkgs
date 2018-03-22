{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, intltool, itstool, libxml2, libgames-support, libgee }:

stdenv.mkDerivation rec {
  name = "gnome-mines-${version}";
  version = "3.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mines/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "2b041eaf0d57307498c56d8e285b2e539f634fdba95d689f6af75aa4ed6edde9";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-mines"; attrPath = "gnome3.gnome-mines"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook librsvg intltool itstool libxml2
    gnome3.defaultIconTheme libgames-support libgee
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Mines;
    description = "Clear hidden mines from a minefield";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
