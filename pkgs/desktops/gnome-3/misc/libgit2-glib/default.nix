{ stdenv, fetchurl, gnome3, libtool, pkgconfig, vala_0_32, libssh2
, gtk_doc, gobjectIntrospection, libgit2, glib }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ gnome3.gnome_common libtool pkgconfig vala_0_32 libssh2
                  gtk_doc gobjectIntrospection libgit2 glib ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
