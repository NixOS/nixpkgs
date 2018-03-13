{ fetchurl, stdenv, pkgconfig, gnome3, intltool, libsoup, json-glib }:

stdenv.mkDerivation rec {
  name = "geocode-glib-${version}";
  version = "3.25.4.1";

  src = fetchurl {
    url = "mirror://gnome/sources/geocode-glib/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0y6p5l2jrr78p7l4hijjhclzbap005y6h06g3aiglg9i5hk6j0gi";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "geocode-glib"; attrPath = "gnome3.geocode-glib"; };
  };

  buildInputs = with gnome3;
    [ intltool pkgconfig glib libsoup json-glib ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };

}
