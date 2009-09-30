{stdenv, fetchurl, python, pkgconfig, libxml2, libxslt, intltool, scrollkeeper}:

stdenv.mkDerivation {
  name = "gnome-doc-utils-0.18.0";
  src = fetchurl {
    url = mirror://gnome/sources/gnome-doc-utils/0.18/gnome-doc-utils-0.18.0.tar.bz2;
    sha256 = "1937zr088vn7vhy9rwfc021ih21hhf700c3m4ria8mlcpcvh1380";
  };
  configureFlags = "--disable-scrollkeeper";
  buildInputs = [ python pkgconfig libxml2 libxslt intltool scrollkeeper ];
}
