{ stdenv, fetchurl, pkgconfig, json_c, hidapi }:

stdenv.mkDerivation rec {
  name = "libu2f-host-0.0.4";

  src = fetchurl {
    url = "https://developers.yubico.com/libu2f-host/Releases/${name}.tar.xz";
    sha256 = "1mpa4m3vchqa0rm1zw0fgby3yhp35k4y6jlqdd02difm3dhk28l5";
  };

  buildInputs = [ pkgconfig json_c hidapi ];

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/libu2f-host;
    description = "a C library and command-line tool thati mplements the host-side of the U2F protocol";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
