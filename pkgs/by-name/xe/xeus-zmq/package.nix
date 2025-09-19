{
  lib,
  clangStdenv,
  fetchFromGitHub,
  cmake,
  cppzmq,
  libuuid,
  nix-update-script,
  nlohmann_json,
  openssl,
  xeus,
  xtl,
  zeromq,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "xeus-zmq";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "jupyter-xeus";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-ODjgOSQfHb9HWhdiWa0seDx0ElhrhhJRj2RfiMaUQGU=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ZeroMQ-based middleware for xeus";
    homepage = "https://github.com/jupyter-xeus/xeus-zmq";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thomasjm ];
    platforms = lib.platforms.all;
  };
})
