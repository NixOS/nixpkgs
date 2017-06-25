{ stdenv, fetchurl, pkgconfig, gnome3
, gtk3, glib, gobjectIntrospection, libarchive
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 glib ];
  propagatedBuildInputs = [ libarchive gobjectIntrospection ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.lgpl21;
    description = "Library to integrate compressed files management with GNOME";
  };
}
