{ stdenv, fetchurl, pkgconfig, json_c, openssl, check, file, help2man, which, gengetopt }:

stdenv.mkDerivation rec {
  name = "libu2f-server-1.1.0";
  src = fetchurl {
    url = "https://developers.yubico.com/libu2f-server/Releases/${name}.tar.xz";
    sha256 = "0xx296nmmqa57w0v5p2kasl5zr1ms2gh6qi4lhv6xvzbmjp3rkcd";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ json_c openssl check file help2man which gengetopt ];

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/libu2f-server/;
    description = "A C library that implements the server-side of the U2F protocol";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ philandstuff ];
  };
}
