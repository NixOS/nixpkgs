{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "cppzmq-${version}";
  version = "2016-01-20";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "cppzmq";
    rev = "68a7b09cfce01c4c279fba2cf91686fcfc566848";
    sha256 = "00dsqqlm8mxhm8kfdspxfln0wzwkyywscnf264afw02k6xf28ndm";
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
