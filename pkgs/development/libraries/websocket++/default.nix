{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "websocket++-${version}";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "zaphoyd";
    repo = "websocketpp";
    rev = version;
    sha256 = "1i64sps52kvy8yffysjbmmbb109pi28kqai0qdxxz1dcj3xfckqd";
  };

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = http://www.zaphoyd.com/websocketpp/;
    description = "C++/Boost Asio based websocket client/server library";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ andir ];
  };
}
