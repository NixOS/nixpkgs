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
    grpc
    libjpeg
    omniorb
    openssl
    opentelemetry-cpp
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
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.gilice ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
