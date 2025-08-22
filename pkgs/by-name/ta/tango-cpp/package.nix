{
  stdenv,
  lib,
  cmake,
  cppzmq,
  curl,
  fetchFromGitLab,
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
  version = "10.1.0";

  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = "cppTango";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-iZ+FJX4+igbnbz8/EFwPpnQcDOs2jTLXxVHD8LEicdA=";
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

  postPatch = ''
    # https://github.com/NixOS/nixpkgs/issues/144170
    substituteInPlace tango.pc.cmake \
        --replace-fail '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  meta = {
    description = "Tango Distributed Control System - C++ library";
    homepage = "https://gitlab.com/tango-controls/cppTango";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.gilice ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
