{
  lib,
  stdenv,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  eigen,
  suitesparse,
  blas,
  lapack,
  libGLU,
  qtbase,
  libqglviewer,
  spdlog,
}:

mkDerivation rec {
  pname = "g2o";
  version = "20230806";

  src = fetchFromGitHub {
    owner = "RainerKuemmerle";
    repo = pname;
    rev = "${version}_git";
    hash = "sha256-9u1FFRWe7qvDhzSKdGTduuGBXmmgzcSriGFb/oCJjNA=";
  };

  # Removes a reference to gcc that is only used in a debug message
  patches = [ ./remove-compiler-reference.patch ];

  outputs = [
    "out"
    "dev"
  ];
  separateDebugInfo = true;

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    eigen
    suitesparse
    blas
    lapack
    libGLU
    qtbase
    libqglviewer
  ];
  propagatedBuildInputs = [ spdlog ];

  dontWrapQtApps = true;

  cmakeFlags =
    [
      # Detection script is broken
      "-DQGLVIEWER_INCLUDE_DIR=${libqglviewer}/include/QGLViewer"
      "-DG2O_BUILD_EXAMPLES=OFF"
    ]
    ++ lib.optionals stdenv.isx86_64 [
      "-DDO_SSE_AUTODETECT=OFF"
      "-DDISABLE_SSE3=${if stdenv.hostPlatform.sse3Support then "OFF" else "ON"}"
      "-DDISABLE_SSE4_1=${if stdenv.hostPlatform.sse4_1Support then "OFF" else "ON"}"
      "-DDISABLE_SSE4_2=${if stdenv.hostPlatform.sse4_2Support then "OFF" else "ON"}"
      "-DDISABLE_SSE4_A=${if stdenv.hostPlatform.sse4_aSupport then "OFF" else "ON"}"
    ];

  meta = with lib; {
    description = "A General Framework for Graph Optimization";
    homepage = "https://github.com/RainerKuemmerle/g2o";
    license = with licenses; [
      bsd3
      lgpl3
      gpl3
    ];
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
    # fatal error: 'qglviewer.h' file not found
    broken = stdenv.isDarwin;
  };
}
