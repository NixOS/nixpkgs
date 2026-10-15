{
  brotli,
  cmake,
  pkg-config,
  fetchFromGitHub,
  lib,
  stdenv,
  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "woff2";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "woff2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-npB7dVjLZXQINa8UtcPtQKdB1Be6c8I5QfkCaEZ5hI4=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  # Need to explicitly link to brotlicommon
  patches = lib.optional static ./brotli-static.patch ++ [ ./gcc15.patch ];

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

    # Fix the build with CMake 4.
    #
    # See: <https://github.com/google/woff2/issues/183>
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required(VERSION 2.8.6)' \
        'cmake_minimum_required(VERSION 3.10)'
  '';

  meta = {
    description = "Webfont compression reference code";
    homepage = "https://github.com/google/woff2";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
