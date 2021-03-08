{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "websocket++";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "zaphoyd";
    repo = "websocketpp";
    rev = version;
    sha256 = "12ffczcrryh74c1xssww35ic6yiy2l2xgdd30lshiq9wnzl2brgy";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = "https://www.zaphoyd.com/websocketpp/";
    description = "C++/Boost Asio based websocket client/server library";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ andir ];
  };
}
