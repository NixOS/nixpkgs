{ fetchurl, stdenv, pkgconfig, gnome3, intltool, libsoup, json-glib }:

stdenv.mkDerivation rec {
  name = "geocode-glib-${version}";
  version = "3.24.0";

  src = fetchurl {
    url = "mirror://gnome/sources/geocode-glib/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "19c1fef4fd89eb4bfe6decca45ac45a2eca9bb7933be560ce6c172194840c35e";
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
