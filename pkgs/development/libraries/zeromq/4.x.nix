{ stdenv, fetchurl, libuuid, pkgconfig, libsodium }:

stdenv.mkDerivation rec {
  name = "zeromq-${version}";
  version = "4.2.0";

  src = fetchurl {
    url = "https://github.com/zeromq/libzmq/releases/download/v${version}/${name}.tar.gz";
    sha256 = "05y1s0938x5w838z79b4f9w6bspz9anldjx9dzvk32cpxvq3pf2k";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libuuid libsodium ];

  meta = with stdenv.lib; {
    branch = "4";
    homepage = "http://www.zeromq.org";
    description = "The Intelligent Transport Layer";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington fpletz ];
  };
}
