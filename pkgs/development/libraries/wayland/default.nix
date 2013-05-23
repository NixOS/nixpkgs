{ stdenv, fetchurl, libffi, expat, pkgconfig, libxslt, docbook_xsl, doxygen }:

stdenv.mkDerivation rec {
  name = "wayland-1.0.5";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";

    sha256 = "130n7v5i7rfsrli2n8vdzfychlgd8v7by7sfgp8vfqdlss5km34w";
  };

  buildInputs = [ pkgconfig libffi expat libxslt docbook_xsl doxygen ];

  meta = {
    description = "The reference implementation of the Wayland protocol";

    homepage = http://wayland.freedesktop.org;

    license = stdenv.lib.licenses.bsd3;

    platforms = stdenv.lib.platforms.all;
  };
}
