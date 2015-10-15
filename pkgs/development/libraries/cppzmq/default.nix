{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "cppzmq-20150926";

  src = fetchgit {
    url = "https://github.com/zeromq/cppzmq";
    rev = "fa2f2c67a79c31d73bfef6862cc8ce12a98dd022";
    sha256 = "7b46712b5fa7e59cd0ffae190674046c71d5762c064003c125d6cd7a3da19b71";
  };

  installPhase = ''
    install -Dm644 zmq.hpp $out/include/zmq.hpp
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/zeromq/cppzmq;
    license = licenses.bsd2;
    description = "C++ binding for 0MQ";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
