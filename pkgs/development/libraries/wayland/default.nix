{ stdenv, fetchurl, pkgconfig, libffi, expat, doxygen }:

let version = "1.0.4"; in

stdenv.mkDerivation rec {
  name = "wayland-${version}";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "074n94d79bqvihf9wmszvar8r9v4g4n1h9m8vs8ki6xjhsk07s4d";
  };

  buildInputs = [ pkgconfig libffi expat doxygen ];

  meta = {
    description = "Reference implementation of the wayland protocol";
    homepage = http://wayland.freedesktop.org/;
    license = stdenv.lib.licenses.mit;
  };
}
