{
  brotli,
  cmake,
  pkg-config,
  fetchFromGitHub,
  lib,
  stdenv,
  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "woff2";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "woff2";
    rev = "v${version}";
    sha256 = "13l4g536h0pr84ww4wxs2za439s0xp1va55g6l478rfbb1spp44y";
  };

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  # Need to explicitly link to brotlicommon
  patches = lib.optional static ./brotli-static.patch;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DCANONICAL_PREFIXES=ON"
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
  ]
  ++ lib.optional static "-DCMAKE_SKIP_RPATH:BOOL=TRUE";

  propagatedBuildInputs = [ brotli ];

  postPatch = ''
    # without this binaries only get built if shared libs are disable
    sed 's@^if (NOT BUILD_SHARED_LIBS)$@if (TRUE)@g' -i CMakeLists.txt

    # gcc=15 reshuffled c++ headers, and the code that assumed that some
    # headers include some others broke.
    sed -i '1 i#include <cstdint>' include/woff2/output.h
  '';

  meta = with lib; {
    description = "Webfont compression reference code";
    homepage = "https://github.com/google/woff2";
    license = licenses.mit;
    maintainers = [ maintainers.hrdinka ];
    platforms = platforms.unix;
  };
}
