{ stdenv, fetchurl, pkgconfig, json_c, hidapi }:

stdenv.mkDerivation rec {
  name = "libu2f-host-0.0.2";

  src = fetchurl {
    url = "https://developers.yubico.com/libu2f-host/Releases/${name}.tar.xz";
    sha256 = "1n6bgb8z7dzyvaqh60gn7p4ih2rbymzflrgy79h3170kbn7lgrf9";
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
