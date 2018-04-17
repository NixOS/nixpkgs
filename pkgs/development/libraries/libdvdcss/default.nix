{stdenv, fetchurl, IOKit}:

stdenv.mkDerivation rec {
  name = "libdvdcss-${version}";
  version = "1.4.1";

  buildInputs = stdenv.lib.optional stdenv.isDarwin IOKit;

  src = fetchurl {
    url = "http://get.videolan.org/libdvdcss/${version}/${name}.tar.bz2";
    sha256 = "1b7awvyahivglp7qmgx2g5005kc5npv257gw7wxdprjsnx93f1zb";
  };

  meta = with stdenv.lib; {
    homepage = http://www.videolan.org/developers/libdvdcss.html;
    description = "A library for decrypting DVDs";
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
  };
}
