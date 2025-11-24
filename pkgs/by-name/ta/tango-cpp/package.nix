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
stdenv.mkDerivation rec {
  pname = "tango-cpp";
  version = "10.1.1";

  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = "cppTango";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-Edv7ZGnESjpuwt0Hentl0qgV2PfBgXWED7v9pUvTW0o=";
  };

  patches = [
    # corresponds to PR https://gitlab.com/tango-controls/cppTango/-/merge_requests/1525
    (fetchpatch {
      url = "https://gitlab.com/tango-controls/cppTango/-/commit/66bd2d9deb79fb557eb2314376f9559e7476d3a1.patch";
      hash = "sha256-ZUcBS4apVfXmXKnpGOQJ9DF8t79qJ2yqKXwaseiOC6U=";
    })
  ];

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
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.gilice ];
  };
}
