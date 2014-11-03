{ stdenv, fetchurl, pkgconfig, json_c, hidapi }:

stdenv.mkDerivation rec {
  name = "libu2f-host-0.0";

  src = fetchurl {
    url = "https://developers.yubico.com/libu2f-host/Releases/${name}.tar.xz";
    sha256 = "02pjald2j6syvxm5pszxcpqhpp7c80hblnzh6wrafkmpkpzi3rq5";
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
