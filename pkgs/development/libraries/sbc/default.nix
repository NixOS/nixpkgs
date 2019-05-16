{ stdenv, fetchurl, pkgconfig, libsndfile }:

stdenv.mkDerivation rec {
  name = "sbc-1.4";

  src = fetchurl {
    url = "http://www.kernel.org/pub/linux/bluetooth/${name}.tar.xz";
    sha256 = "1jal98pnrjkzxlkiqy0ykh4qmgnydz9bmsp1jn581p5kddpg92si";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libsndfile ];

  meta = with stdenv.lib; {
    description = "SubBand Codec Library";
    homepage = http://www.bluez.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
