{ stdenv, fetchurl, gnome3, libtool, pkgconfig, vala, libssh2
, gtk-doc, gobjectIntrospection, libgit2, glib }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [
    gnome3.gnome-common libtool pkgconfig vala gtk-doc gobjectIntrospection
  ];

  propagatedBuildInputs = [
    # Required by libgit2-glib-1.0.pc
    libgit2 glib
  ];

  buildInputs = [ libssh2 ];

  meta = with stdenv.lib; {
    description = "A glib wrapper library around the libgit2 git access library";
    homepage = https://wiki.gnome.org/Projects/Libgit2-glib;
    license = licenses.lgpl21;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
