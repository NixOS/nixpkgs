{ stdenv, fetchurl, pkgconfig, intltool
, glib, gtk3, gobjectIntrospection, python, pygobject3
}:

stdenv.mkDerivation rec {
  name = "libpeas-${version}";
  version = "1.9.0";

  buildInputs =  [
   intltool pkgconfig
   glib gtk3 gobjectIntrospection python pygobject3
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libpeas/1.9/${name}.tar.xz";
    sha256 = "13fzyzv6c0cfdj83z1s16lv8k997wpnzyzr0wfwcfkcmvz64g1q0";
  };

  preFixup = ''
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = {
    description = "A GObject-based plugins engine";
    homepage = "http://ftp.acc.umu.se/pub/GNOME/sources/libpeas/";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
