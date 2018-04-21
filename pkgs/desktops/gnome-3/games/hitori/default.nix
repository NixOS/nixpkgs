{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, libxml2, intltool, itstool }:

stdenv.mkDerivation rec {
  name = "hitori-${version}";
  version = "3.22.4";

  src = fetchurl {
    url = "mirror://gnome/sources/hitori/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "dcac6909b6007857ee425ac8c65fed179f2c71da138d5e5300cd62c8b9ea15d3";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "hitori"; attrPath = "gnome3.hitori"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook intltool itstool libxml2
    gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Hitori;
    description = "GTK+ application to generate and let you play games of Hitori";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
