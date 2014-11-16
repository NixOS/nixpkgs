{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "cppzmq";

  src = fetchgit {
    url = "https://github.com/zeromq/cppzmq";
    rev = "1f05e0d111197c64be32ad5aecd59f4d1b05a819";
    sha256 = "3a3507fd5646f191088e7a0a7a09846da54b0cac0fcb08f7c4c8d510b484e6da";
  };

  installPhase = ''
    install -Dm644 zmq.hpp $out/include/zmq.hpp
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/zeromq/cppzmq;
    license = licenses.bsd2;
    description = "C++ binding for 0MQ";
    maintainers = maintainers.abbradar;
    platforms = platforms.unix;
  };
}
