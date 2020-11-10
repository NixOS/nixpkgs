{stdenv, fetchurl, IOKit}:

stdenv.mkDerivation rec {
  pname = "libdvdcss";
  version = "1.4.2";

  buildInputs = stdenv.lib.optional stdenv.isDarwin IOKit;

  src = fetchurl {
    url = "http://get.videolan.org/libdvdcss/${version}/${pname}-${version}.tar.bz2";
    sha256 = "0x957zzpf4w2cp8zlk29prj8i2q6hay3lzdzsyz8y3cwxivyvhkq";
  };

  meta = with stdenv.lib; {
    homepage = "http://www.videolan.org/developers/libdvdcss.html";
    description = "A library for decrypting DVDs";
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
  };
}
