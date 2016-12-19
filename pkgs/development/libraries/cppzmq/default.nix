{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "cppzmq-${version}";
  version = "2016-11-16";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "cppzmq";
    rev = "8b52a6ffacce27bac9b81c852b81539a77b0a6e5";
    sha256 = "12accjyjzfw1wqzbj1qn6q99bj5ba05flsvbanyzflr3b4971s4p";
  };

  installPhase = ''
    install -Dm644 zmq.hpp $out/include/zmq.hpp
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/zeromq/cppzmq";
    license = licenses.bsd2;
    description = "C++ binding for 0MQ";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
