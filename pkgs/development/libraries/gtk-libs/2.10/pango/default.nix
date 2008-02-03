args: with args;

stdenv.mkDerivation {
  name = "pango-1.14.10";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/pango/1.14/pango-1.14.10.tar.bz2;
    md5 = "e9fc2f8168e74e2fa0aa8238ee0e9c06";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [x11 glib cairo libpng];
}
