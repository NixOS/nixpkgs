{ stdenv, fetchurl, pkgconfig, libsndfile }:

stdenv.mkDerivation rec {
  pname = "sbc";
  version = "1.5";

  src = fetchurl {
    url = "http://www.kernel.org/pub/linux/bluetooth/${pname}-${version}.tar.xz";
    sha256 = "1liig5856crb331dps18mp0s13zbkv7yh007zqhq97m94fcddfhc";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libsndfile ];

  meta = with stdenv.lib; {
    description = "SubBand Codec Library";
    homepage = "http://www.bluez.org/";
    maintainers = with maintainers; [ gebner ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
