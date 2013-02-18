{ stdenv, fetchurl, pkgconfig, libffi, expat, doxygen }:

let version = "1.0.5"; in

stdenv.mkDerivation rec {
  name = "wayland-${version}";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "130n7v5i7rfsrli2n8vdzfychlgd8v7by7sfgp8vfqdlss5km34w";
  };

  buildInputs = [ pkgconfig libffi expat doxygen ];

  meta = {
    description = "Reference implementation of the wayland protocol";
    homepage = http://wayland.freedesktop.org/;
    license = stdenv.lib.licenses.mit;
  };
}
