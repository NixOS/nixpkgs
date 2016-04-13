{ stdenv, fetchurl, libuuid, pkgconfig, libsodium }:

stdenv.mkDerivation rec {
  name = "zeromq-4.1.4";

  src = fetchurl {
    url = "http://download.zeromq.org/${name}.tar.gz";
    sha256 = "0y73dxgf4kaysmkvrkxqq9qk5znklxyghh749jw4qbjwwbyl97z9";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libuuid libsodium ];

  meta = with stdenv.lib; {
    branch = "4";
    homepage = "http://www.zeromq.org";
    description = "The Intelligent Transport Layer";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
