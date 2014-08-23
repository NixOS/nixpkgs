{ stdenv, fetchurl, gnome3, libtool, pkgconfig
, gtk_doc, gobjectIntrospection, libgit2, glib }:

stdenv.mkDerivation rec {
  name = "libgit2-glib-${version}";
  version = "0.0.10";

  src = fetchurl {
    url = "https://github.com/GNOME/libgit2-glib/archive/v${version}.tar.gz";
    sha256 = "0zn3k85jw6yks8s5ca8dyh9mwh4if1lni9gz9bd5lqlpa803ixxs";
  };

  configureScript = "sh ./autogen.sh";

  buildInputs = [ gnome3.gnome_common libtool pkgconfig
                  gtk_doc gobjectIntrospection libgit2 glib ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
