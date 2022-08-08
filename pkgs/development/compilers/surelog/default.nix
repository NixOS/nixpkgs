{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, python310Packages
, jdk11
, libunwind
, libuuid
, gperftools
}:

stdenv.mkDerivation rec {
  pname = "surelog";
  version = "1.35";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = "Surelog";
    rev = "b2e6116912c4de39fdcdcb753695fd5b0481b2cb";
    hash = "sha256-2ktVE3XHV4+KEe7AtvqqpJKnpi1Pvwnt13t8MeL/g9Q=";
    fetchSubmodules = true;
  };

  buildInputs = [
    libunwind
    libuuid
    gperftools                # tcmalloc for more performant parsing
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    jdk11                     # For antlr grammar code generation
    python310Packages.python  # For various surelog/UHDM code generation
    python310Packages.orderedmultidict
    python310Packages.psutil
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    make -j $NIX_BUILD_CORES UnitTests
    ctest --output-on-failure
    runHook postCheck
    '';

  meta = with lib; {
    homepage = "https://github.com/chipsalliance/Surelog";
    description = "SystemVerilog 2017 Pre-processor, Parser, Elaborator, UHDM Compiler";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hzeller ];
  };
}
