{ stdenv, fetchurl, pkgconfig, gnome3, intltool, itstool, gtk3
, wrapGAppsHook, gconf, librsvg, libxml2, desktop_file_utils
, guile, libcanberra_gtk3 }:

stdenv.mkDerivation rec {
  name = "aisleriot-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/aisleriot/${gnome3.version}/${name}.tar.xz";
    sha256 = "0rncdg21ys7ik971yw75qbawq89mikbh4dq5mg2msmrl6xsgv0zl";
  };

  configureFlags = [ "--with-card-theme-formats=svg" ];

  buildInputs = [ pkgconfig intltool itstool gtk3 wrapGAppsHook gconf
                  librsvg libxml2 desktop_file_utils guile libcanberra_gtk3 ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Aisleriot;
    description = "A collection of patience games written in guile scheme";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
