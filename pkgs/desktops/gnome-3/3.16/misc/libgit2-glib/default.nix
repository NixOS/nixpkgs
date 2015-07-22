{ stdenv, fetchurl, gnome3, libtool, pkgconfig, vala
, gtk_doc, gobjectIntrospection, libgit2, glib }:

let
  majorVersion = "0.0";
in
stdenv.mkDerivation rec {
  name = "libgit2-glib-${majorVersion}.24";

  src = fetchurl {
    url = "mirror://gnome/sources/libgit2-glib/0.0/${name}.tar.xz";
    sha256 = "8a0a6f65d86f2c8cb9bcb20c5e0ea6fd02271399292a71fc7e6852f13adbbdb8";
  };

  buildInputs = [ gnome3.gnome_common libtool pkgconfig vala
                  gtk_doc gobjectIntrospection libgit2 glib ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
