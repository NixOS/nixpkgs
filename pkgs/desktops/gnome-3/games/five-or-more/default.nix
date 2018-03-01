{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "five-or-more-${version}";
  version = "3.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/five-or-more/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "7c24f7f2603df99299d38b40b14c005aaad88820113ed71e4b3765ac3b027772";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "five-or-more"; attrPath = "gnome3.five-or-more"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook librsvg intltool itstool libxml2
    gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Five_or_more;
    description = "Remove colored balls from the board by forming lines";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
