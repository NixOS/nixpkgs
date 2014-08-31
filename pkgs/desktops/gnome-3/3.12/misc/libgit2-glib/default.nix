{ stdenv, fetchurl, gnome3, libtool, pkgconfig, vala
, gtk_doc, gobjectIntrospection, libgit2, glib }:

stdenv.mkDerivation rec {
  name = "libgit2-glib-${version}";
  version = "0.0.20";

  src = fetchurl {
    url = "https://github.com/GNOME/libgit2-glib/archive/v${version}.tar.gz";
    sha256 = "1s2hj0ji73ishniqvr6mx90l1ji5jjwwrwhp91i87fxk0d3sry5x";
  };

  configureScript = "sh ./autogen.sh";

  buildInputs = [ gnome3.gnome_common libtool pkgconfig vala
                  gtk_doc gobjectIntrospection libgit2 glib ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
