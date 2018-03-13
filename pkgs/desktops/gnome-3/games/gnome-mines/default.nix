{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, intltool, itstool, libxml2, libgames-support, libgee }:

stdenv.mkDerivation rec {
  name = "gnome-mines-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mines/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "16w55hqaxipcv870n9gpn6qiywbqbyg7bjshaa02r75ias8dfxvf";
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
