{
  cmake,
  cppzmq,
  fetchFromGitHub,
  lib,
  libuuid,
  nlohmann_json,
  openssl,
  stdenv,
  xeus,
  zeromq,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xeus-zmq";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "jupyter-xeus";
    repo = "xeus-zmq";
    tag = finalAttrs.version;
    hash = "sha256-58eJMZK3pDxW3BJHuBznXa008OBd3cvBrhLKAP5Nrrs=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    cppzmq
    libuuid
    openssl
    xeus
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
})
