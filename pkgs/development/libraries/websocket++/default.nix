{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "websocket++-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "zaphoyd";
    repo = "websocketpp";
    rev = version;
    sha256 = "1n6j0dh3qpis0f7crd49a2nhxd5459h0blch408z3kwlasx2g0i5";
  };

  buildInputs = [ cmake ];

  meta = {
    homepage = http://www.zaphoyd.com/websocketpp/;
    description = "C++/Boost Asio based websocket client/server library";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
  };
}
