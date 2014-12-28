{ stdenv, fetchurl, pkgconfig, json_c, hidapi }:

stdenv.mkDerivation rec {
  name = "libu2f-host-0.0.1";

  src = fetchurl {
    url = "https://developers.yubico.com/libu2f-host/Releases/${name}.tar.xz";
    sha256 = "1cqgvbh2fim9r7pjazph64xnrhmsydqh8xrnxd4g16mc0k76s4mf";
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
