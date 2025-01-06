{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "websocket++";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "zaphoyd";
    repo = "websocketpp";
    rev = version;
    sha256 = "sha256-9fIwouthv2GcmBe/UPvV7Xn9P2o0Kmn2hCI4jCh0hPM=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://www.zaphoyd.com/websocketpp/";
    description = "C++/Boost Asio based websocket client/server library";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ revol-xut ];
  };
}
