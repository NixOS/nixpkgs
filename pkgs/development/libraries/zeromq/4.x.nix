{ stdenv, fetchurl, libuuid, pkgconfig, libsodium }:

stdenv.mkDerivation rec {
  name = "zeromq-4.1.2";

  src = fetchurl {
    url = "http://download.zeromq.org/${name}.tar.gz";
    sha256 = "09sr6ix4k25m3fw6c8xhicq5g27q0k1vlwfqai8iwlk8dnnjw5pr";
  };

  buildInputs = [ libuuid pkgconfig libsodium ];

  meta = with stdenv.lib; {
    branch = "4";
    homepage = "http://www.zeromq.org";
    description = "The Intelligent Transport Layer";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
