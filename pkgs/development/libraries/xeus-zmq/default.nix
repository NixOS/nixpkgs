{ lib
, clangStdenv
, fetchFromGitHub
, cmake
, cppzmq
, libuuid
, nlohmann_json
, openssl
, xeus
, xtl
, zeromq
}:

clangStdenv.mkDerivation rec {
  pname = "xeus-zmq";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "jupyter-xeus";
    repo = "xeus-zmq";
    rev = "${version}";
    hash = "sha256-sfGXo6CPJu5TJrkecLLoaQxrGaJbeQG+QiCkltAwuI8=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    cppzmq
    libuuid
    openssl
    xeus
    xtl
    zeromq
  ];

  propagatedBuildInputs = [ nlohmann_json ];

  meta = {
    description = "ZeroMQ-based middleware for xeus";
    homepage = "https://github.com/jupyter-xeus/xeus-zmq";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thomasjm ];
    platforms = lib.platforms.all;
  };
}
