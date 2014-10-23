{ stdenv, fetchurl, libffi, expat, pkgconfig, libxslt, docbook_xsl, doxygen }:

let version = "1.6.0"; in

stdenv.mkDerivation rec {
  name = "wayland-${version}";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "0zzwlrmxil10g9rvdgha0y1d8z0x97g65g14kl2qrl2krwni1md7";
  };

  buildInputs = [ pkgconfig libffi expat libxslt docbook_xsl doxygen ];

  meta = {
    description = "Reference implementation of the wayland protocol";
    homepage = http://wayland.freedesktop.org/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
