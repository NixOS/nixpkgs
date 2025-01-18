{
  lib,
  clangStdenv,
  fetchFromGitHub,
  cmake,
  cppzmq,
  libuuid,
  nlohmann_json,
  openssl,
  xeus,
  xtl,
  zeromq,
}:

clangStdenv.mkDerivation rec {
  pname = "xeus-zmq";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "jupyter-xeus";
    repo = "xeus-zmq";
    rev = "${version}";
    hash = "sha256-CrFb0LDb6akCfFnwMSa4H3D3A8KJx9Kiejw6VeV3IDs=";
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

  meta = with lib; {
    description = "ZeroMQ-based middleware for xeus";
    homepage = "https://github.com/jupyter-xeus/xeus-zmq";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thomasjm ];
    platforms = platforms.all;
  };
}
