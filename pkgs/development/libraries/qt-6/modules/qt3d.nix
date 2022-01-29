{ qtModule
, qtbase
, qtdeclarative
, qtmultimedia
, assimp
}:

qtModule {
  pname = "qt3d";
  qtInputs = [ qtbase qtdeclarative qtmultimedia ];
  propagatedBuildInputs = [ assimp ]; # TODO buildInputs?
  outputs = [ "out" "dev" "bin" ];
  cmakeFlags = [
    "-DQT_FEATURE_qt3d_vulkan=ON"
    #"-DQT_FEATURE_qt3d_simd_avx2=ON" # avx2 would be nice, but is not portable?
  ];
}
