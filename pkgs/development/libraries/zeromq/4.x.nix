{ stdenv, fetchurl, libuuid, pkgconfig, libsodium }:

stdenv.mkDerivation rec {
  name = "zeromq-${version}";
  version = "4.2.2";

  src = fetchurl {
    url = "https://github.com/zeromq/libzmq/releases/download/v${version}/${name}.tar.gz";
    sha256 = "0syzwsiqblimfjb32fr6hswhdvp3cmbk0pgm7ayxaigmkv5g88sv";
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
