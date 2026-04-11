{
  stdenv,
  lib,
  cmake,
  cppzmq,
  curl,
  fetchFromGitLab,
  fetchpatch,
  libjpeg,
  omniorb,
  openssl,
  opentelemetry-cpp,
  protobuf,
  tango-idl,
  zeromq,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tango-cpp";
  version = "10.3.0";

  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = "cppTango";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-X4r2nMdW61TAqDLcVZ0tibJnn/ffXHt8RWSBDRqA0/8=";
  };

  nativeBuildInputs = [
    cmake
    cppzmq
    tango-idl
  ];

  buildInputs = [
    curl
    libjpeg
    omniorb
    openssl
    (opentelemetry-cpp.override {
      enableGrpc = true;
      enableHttp = true;
    })
    protobuf
    zeromq
  ];

  meta = {
    description = "Tango Distributed Control System - C++ library";
    homepage = "https://gitlab.com/tango-controls/cppTango";
    changelog = "https://gitlab.com/tango-controls/cppTango/-/blob/${finalAttrs.version}/RELEASE_NOTES.md";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.gilice ];
  };
})
