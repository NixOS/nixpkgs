{ lib, stdenv, mkDerivation, fetchFromGitHub, cmake, eigen, suitesparse, libGLU
, qtbase, libqglviewer, makeWrapper }:

mkDerivation rec {
  pname = "g2o";
  version = "20200410";

  src = fetchFromGitHub {
    owner = "RainerKuemmerle";
    repo = pname;
    rev = "${version}_git";
    sha256 = "11rgj2g9mmwajlr69pjkjvxjyn88afa0r4bchjyvmxswjccizlg2";
  };

  # Removes a reference to gcc that is only used in a debug message
  patches = [ ./remove-compiler-reference.patch ];

  separateDebugInfo = true;

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ eigen suitesparse libGLU qtbase libqglviewer ];

  # Silence noisy warning
  CXXFLAGS = "-Wno-deprecated-copy";

  cmakeFlags = [
    # Detection script is broken
    "-DQGLVIEWER_INCLUDE_DIR=${libqglviewer}/include/QGLViewer"
    "-DG2O_BUILD_EXAMPLES=OFF"
  ] ++ lib.optionals stdenv.isx86_64 [
    "-DDO_SSE_AUTODETECT=OFF"
    "-DDISABLE_SSE3=${  if stdenv.hostPlatform.sse3Support   then "OFF" else "ON"}"
    "-DDISABLE_SSE4_1=${if stdenv.hostPlatform.sse4_1Support then "OFF" else "ON"}"
    "-DDISABLE_SSE4_2=${if stdenv.hostPlatform.sse4_2Support then "OFF" else "ON"}"
    "-DDISABLE_SSE4_A=${if stdenv.hostPlatform.sse4_aSupport then "OFF" else "ON"}"
  ];

  meta = with lib; {
    description = "A General Framework for Graph Optimization";
    homepage = "https://github.com/RainerKuemmerle/g2o";
    license = with licenses; [ bsd3 lgpl3 gpl3 ];
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
}
