{ stdenv, fetchurl, pkgconfig, json_c, openssl, check }:

stdenv.mkDerivation rec {
  name = "libu2f-server-1.0.1";

  src = fetchurl {
    url = "https://developers.yubico.com/libu2f-server/Releases/${name}.tar.xz";
    sha256 = "0vhzixz1s629qv9dpdj6b7fxfyxnr5j2vx2cq9q6v790a68ga656";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ json_c openssl check ];

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/libu2f-server/;
    description = "A C library that implements the server-side of the U2F protocol";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ philandstuff ];
  };
}
