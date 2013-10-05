{ stdenv, fetchurl, libffi, expat, pkgconfig, libxslt, docbook_xsl, doxygen }:

let version = "1.2.1"; in

stdenv.mkDerivation rec {
  name = "wayland-${version}";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "0vqngxpavcxvjwlw7afgrbv7qvmd489sj555wrnxjc8p10mjw1kq";
  };

  buildInputs = [ pkgconfig libffi expat libxslt docbook_xsl doxygen ];

  meta = {
    description = "Reference implementation of the wayland protocol";
    homepage = http://wayland.freedesktop.org/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
