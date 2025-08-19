{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gitMinimal,
  pkg-config,
  lcms2,
  tinyxml,
  boost,
}:

stdenv.mkDerivation (finalAtts: {
  pname = "opencolorio";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "imageworks";
    repo = "OpenColorIO";
    tag = "v${finalAtts.version}";
    hash = "sha256-S6N0WK0CQ1wOL77viA6vBNkkW7xLPUClu5+FoljfWYs=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  # TODO: Investigate whether git can be dropped: It's only used to apply patches
  nativeBuildInputs = [
    cmake
    gitMinimal
    pkg-config
  ];

  buildInputs = [
    lcms2
    tinyxml
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin boost;

  postPatch = ''
    substituteInPlace src/core/CMakeLists.txt --replace "-Werror" ""
    substituteInPlace src/pyglue/CMakeLists.txt --replace "-Werror" ""
  '';

  cmakeFlags = [
    "-DUSE_EXTERNAL_LCMS=ON"
    "-DUSE_EXTERNAL_TINYXML=ON"
    # External yaml-cpp 0.6.* not compatible: https://github.com/imageworks/OpenColorIO/issues/517
    "-DUSE_EXTERNAL_YAML=OFF"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "-DOCIO_USE_BOOST_PTR=ON"
  ++ lib.optional (!stdenv.hostPlatform.isx86) "-DOCIO_USE_SSE=OFF"
  ++ lib.optional (
    stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64
  ) "-DCMAKE_OSX_ARCHITECTURES=arm64";

  env = lib.optionalAttrs stdenv.cc.isClang {
    # yaml-cpp uses std::auto_ptr and std::binary_function which has
    # been disabled in clang with libcxx. These flags re-enables these
    # features
    NIX_CXXSTDLIB_COMPILE = "-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR=1 -D_LIBCPP_ENABLE_CXX17_REMOVED_UNARY_BINARY_FUNCTION=1";
  };

  postInstall = ''
    moveToOutput bin "$bin"
    moveToOutput cmake "$dev"
    mv $out/OpenColorIOConfig.cmake $dev/cmake/

    substituteInPlace "$dev/cmake/OpenColorIO-release.cmake" \
      --replace "$out/bin" "$bin/bin"
  '';

  meta = {
    homepage = "https://opencolorio.org";
    description = "Color management framework for visual effects and animation";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ yzx9 ];
    platforms = lib.platforms.unix;
  };
})
