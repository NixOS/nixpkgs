{ stdenv, fetchurl, pkgconfig, glib, libsoup, gobjectIntrospection, gnome3 }:

stdenv.mkDerivation rec {
  name = "rest-${version}";
  major = "0.8";
  version = "${major}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/rest/${major}/${name}.tar.xz";
    sha256 = "e7b89b200c1417073aef739e8a27ff2ab578056c27796ec74f5886a5e0dff647";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libsoup gobjectIntrospection];

  configureFlags = "--with-ca-certificates=/etc/ssl/certs/ca-certificates.crt";

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
