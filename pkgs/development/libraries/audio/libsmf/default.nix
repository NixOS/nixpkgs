{ lib, stdenv, fetchurl, glib, pkgconfig }:

stdenv.mkDerivation rec {
  version = "1.3";
  name = "libsmf-${version}";
  src = fetchurl {
    url = "https://github.com/stump/libsmf/archive/${name}.tar.gz";
    sha256 = "16c0n40h0r56gzbh5ypxa4dwp296dan3jminml2qkb4lvqarym6k";
  };

  buildInputs = [ glib pkgconfig ];

  meta = with stdenv.lib; {
    description = "A C library for reading and writing Standard MIDI Files";
    homepage = https://github.com/stump/libsmf;
    license = licenses.bsd2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
