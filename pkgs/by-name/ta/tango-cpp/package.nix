{
  stdenv,
  lib,
  cmake,
  cppzmq,
  fetchFromGitLab,
  grpc,
  libjpeg,
  omniorb,
  openssl,
  opentelemetry-cpp,
  protobuf,
  tango-idl,
  zeromq,
}:
stdenv.mkDerivation {
  pname = "tango-cpp";
  version = "10.1.0";
  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = "cppTango";
    rev = "10.1.0";
    hash = "sha256-iZ+FJX4+igbnbz8/EFwPpnQcDOs2jTLXxVHD8LEicdA=";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [
    tango-idl
    cmake
    zeromq
    cppzmq
    omniorb
    openssl
    opentelemetry-cpp
    libjpeg
    grpc
    protobuf
  ];
  postPatch = ''
    # https://github.com/NixOS/nixpkgs/pull/172150/
    substituteInPlace tango.pc.cmake \
        --replace-warn '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';
  meta = {
    description = "Tango Distributed Control System - C++ library";
    homepage = "https://gitlab.com/tango-controls/cppTango";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.gilice ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
