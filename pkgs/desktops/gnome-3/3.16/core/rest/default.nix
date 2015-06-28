{ stdenv, fetchurl, pkgconfig, glib, libsoup, gobjectIntrospection, cacert }:

stdenv.mkDerivation rec {
  name = "rest-0.7.92";

  src = fetchurl {
    url = "mirror://gnome/sources/rest/0.7/${name}.tar.xz";
    sha256 = "07548c8785a3e743daf54a82b952ff5f32af94fee68997df4c83b00d52f9c0ec";
  };

  buildInputs = [ pkgconfig glib libsoup gobjectIntrospection];

  configureFlags = "--with-ca-certificates=${cacert}/etc/ssl/certs/ca-bundle.crt";

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
