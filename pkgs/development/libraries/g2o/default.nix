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
  ] ++ lib.optionals stdenv.isx86_64 ([ "-DDO_SSE_AUTODETECT=OFF" ] ++ {
    default        = [ "-DDISABLE_SSE3=ON" "-DDISABLE_SSE4_1=ON" "-DDISABLE_SSE4_2=ON" "-DDISABLE_SSE4_A=ON" ];
    westmere       = [                                                                 "-DDISABLE_SSE4_A=ON" ];
    sandybridge    = [                                                                 "-DDISABLE_SSE4_A=ON" ];
    ivybridge      = [                                                                 "-DDISABLE_SSE4_A=ON" ];
    haswell        = [                                                                 "-DDISABLE_SSE4_A=ON" ];
    broadwell      = [                                                                 "-DDISABLE_SSE4_A=ON" ];
    skylake        = [                                                                 "-DDISABLE_SSE4_A=ON" ];
    skylake-avx512 = [                                                                 "-DDISABLE_SSE4_A=ON" ];
  }.${stdenv.hostPlatform.platform.gcc.arch or "default"});

  meta = with lib; {
    description = "A General Framework for Graph Optimization";
    homepage = "https://github.com/RainerKuemmerle/g2o";
    license = with licenses; [ bsd3 lgpl3 gpl3 ];
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
}
