{ stdenv, fetchurl, pkgconfig, libffi, expat, doxygen }:

let version = "1.0.3"; in

stdenv.mkDerivation rec {
  name = "wayland-${version}";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "04sr7bl1f0qk837qpc9zpxirkgvlp3pval3326mbld553ghmxgpn";
  };

  buildInputs = [ pkgconfig libffi expat doxygen ];

  meta = {
    description = "Reference implementation of the wayland protocol";
    homepage = http://wayland.freedesktop.org/;
    license = stdenv.lib.licenses.mit;
  };
}
