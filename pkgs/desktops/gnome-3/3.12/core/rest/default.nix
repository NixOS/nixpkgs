{ stdenv, fetchurl, pkgconfig, glib, libsoup, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "rest-0.7.91";

  src = fetchurl {
    url = "mirror://gnome/sources/rest/0.7/${name}.tar.xz";
    sha256 = "838814d935143f2dc99eb79f1ac69c615e7b547339f6cd226dd0ed4d7c16b67a";
  };

  buildInputs = [ pkgconfig glib libsoup gobjectIntrospection];

  configureFlags = "--with-ca-certificates=/etc/ssl/certs/ca-bundle.crt";

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
