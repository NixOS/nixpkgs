{ lib
, stdenv
, fetchFromGitHub
, cmake
, asio
, rapidjson
, websocketpp
}:

stdenv.mkDerivation {
  pname = "sioclient";
  version = "unstable-2023-02-13";

  src = fetchFromGitHub {
    owner = "socketio";
    repo = "socket.io-client-cpp";
    rev = "b10474e3eaa6b27e75dbc1382ac9af74fdf3fa85";
    hash = "sha256-bkuFA6AvZvBpnO6Lixqx8Ux5Dy5NHWGB2y1VF7allC0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    asio
    rapidjson
    websocketpp
  ];

  meta = with lib; {
    description = "C++11 implementation of Socket.IO client";
    homepage = "https://github.com/socketio/socket.io-client-cpp";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
