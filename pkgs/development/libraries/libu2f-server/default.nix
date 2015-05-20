{ stdenv, fetchurl, pkgconfig, json_c, hidapi, openssl, check }:

stdenv.mkDerivation rec {
  name = "libu2f-server-0.0.0";

  src = fetchurl {
    url = "https://developers.yubico.com/libu2f-server/Releases/libu2f-server-0.0.0.tar.xz";
    sha256 = "1vdl3qavzfpi6p6h48zw17md9wykfzpay5c4l1c08id46m560wp0";
  };

  buildInputs = [ pkgconfig json_c hidapi openssl check ];

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/libu2f-server/;
    description = "A C library that implements the server-side of the U2F protocol";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ philandstuff ];
  };
}
