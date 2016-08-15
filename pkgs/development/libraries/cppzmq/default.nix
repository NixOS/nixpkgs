{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "cppzmq-${version}";
  version = "2016-07-18";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "cppzmq";
    rev = "92d2af6def80a01b76d5e73f073c439ad00ab757";
    sha256 = "0lnwh314hh5ifad2sa2nz1g1ld1jc4vplm7clyvx304sjjvbvl27";
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
