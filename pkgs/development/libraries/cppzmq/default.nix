{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "cppzmq-2015-07-06";

  src = fetchgit {
    url = "https://github.com/zeromq/cppzmq";
    rev = "a88bf3e0b0bc6ed5f5b25a58f8997a1dae374c8b";
    sha256 = "75a6630b870c1f0d5b9d6a0ba03e83ceee47aaa2a253894e75a8a93a6d65d3aa";
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
