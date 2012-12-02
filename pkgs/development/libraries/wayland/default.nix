{ stdenv, fetchurl, pkgconfig, libffi, expat, doxygen }:

let version = "1.0.2"; in

stdenv.mkDerivation rec {
  name = "wayland-${version}";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "0q2p83s2c7l5n6yzii3f2r6wrl3bd99d0v0fai21pb4jwijmxq71";
  };

  buildInputs = [ pkgconfig libffi expat doxygen ];

  meta = {
    description = "Reference implementation of the wayland protocol";
    homepage = http://wayland.freedesktop.org/;
    license = stdenv.lib.licenses.mit;
  };
}
