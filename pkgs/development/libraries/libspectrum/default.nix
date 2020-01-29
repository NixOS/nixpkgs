{ lib, stdenv, fetchurl, perl, pkgconfig, audiofile, bzip2, glib, libgcrypt, zlib }:

stdenv.mkDerivation rec {
  name = "libspectrum-1.4.4";

  src = fetchurl {
    url = "mirror://sourceforge/fuse-emulator/${name}.tar.gz";
    sha256 = "1cc0jx617sym6qj1f9fm115q44cq5azsxplqq2cgrg0pmlmjpyzx";
  };

  nativeBuildInputs = [ perl pkgconfig ];

  buildInputs = [ audiofile bzip2 glib libgcrypt zlib ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = http://fuse-emulator.sourceforge.net/libspectrum.php;
    description = "ZX Spectrum input and output support library";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
