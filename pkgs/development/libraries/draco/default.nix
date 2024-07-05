{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, cmake
, python3
, gtest
, withAnimation ? true
, withTranscoder ? true
, eigen
, ghc_filesystem
, tinygltf
}:

let
  cmakeBool = b: if b then "ON" else "OFF";
in
stdenv.mkDerivation (finalAttrs: {
  version = "1.5.7";
  pname = "draco";

  src = fetchFromGitHub {
    owner = "google";
    repo = "draco";
    rev = finalAttrs.version;
    hash = "sha256-p0Mn4kGeBBKL7Hoz4IBgb6Go6MdkgE7WZgxAnt1tE/0=";
    fetchSubmodules = true;
  };

  # ld: unknown option: --start-group
  postPatch = ''
    substituteInPlace cmake/draco_targets.cmake \
      --replace "^Clang" "^AppleClang"
  '';

  buildInputs = [ gtest ]
    ++ lib.optionals withTranscoder [ eigen ghc_filesystem tinygltf ];

  nativeBuildInputs = [ cmake python3 ];

  cmakeFlags = [
    "-DDRACO_ANIMATION_ENCODING=${cmakeBool withAnimation}"
    "-DDRACO_GOOGLETEST_PATH=${gtest}"
    "-DBUILD_SHARED_LIBS=${cmakeBool true}"
    "-DDRACO_TRANSCODER_SUPPORTED=${cmakeBool withTranscoder}"
  ] ++ lib.optionals withTranscoder [
    "-DDRACO_EIGEN_PATH=${eigen}/include/eigen3"
    "-DDRACO_FILESYSTEM_PATH=${ghc_filesystem}"
    "-DDRACO_TINYGLTF_PATH=${tinygltf}"
  ];

  CXXFLAGS = [
    # error: expected ')' before 'value' in 'explicit GltfValue(uint8_t value)'
    "-include cstdint"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Library for compressing and decompressing 3D geometric meshes and point clouds";
    homepage = "https://google.github.io/draco/";
    changelog = "https://github.com/google/draco/releases/tag/${finalAttrs.version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ jansol ];
    platforms = platforms.all;
  };
})
