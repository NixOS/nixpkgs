{ stdenv, fetchurl, libffi, expat, pkgconfig, libxslt, docbook_xsl, doxygen }:

let version = "1.3.0"; in

stdenv.mkDerivation rec {
  name = "wayland-${version}";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "0vhd8z74r4zmm7hrbb8l450sb6slqkdrvmk4k78sq9lays2pd09f";
  };

  buildInputs = [ pkgconfig libffi expat libxslt docbook_xsl doxygen ];

  meta = {
    description = "Reference implementation of the wayland protocol";
    homepage = http://wayland.freedesktop.org/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
