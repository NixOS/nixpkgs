{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  pkg-config,

  bzip2,
  feather-tk,
  ffmpeg,
  freetype,
  glfw,
  imath,
  libGL,
  libjpeg,
  libtiff,
  libpng,
  lunasvg,
  minizip-ng,
  nativefiledialog-extended,
  nlohmann_json,
  opencolorio,
  openexr,
  openssl,
  opentimelineio,
  plutovg,
  SDL2,
  sdl3,
  xz,
  zlib,
  zstd,

  enableShared ? !stdenv.hostPlatform.isStatic,
  # enableNet ? false,
  enableNet ? true,
  enableSdl2 ? true,
  enableSdl3 ? false,
  enableJpeg ? true,
  enableTiff ? true,
  enableStb ? true,
  enablePng ? true,
  enableOpenexr ? true,
  enableFfmpeg ? true,
# usdSupport ? false,
# bmdSupport ? false,
# qt6Support ? false,
# qt5Support ? false,

# PROGRAMS ON
# EXAMPLES ON
# TESTS ON
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tlrender";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "darbyjohnston";
    repo = "tlRender";
    tag = finalAttrs.version;
    hash = "sha256-TxiDZtMvNmrV1FKXZnekCZHnr/eCWZlsP6VJRnaoWg4=";
  };

  patches = [
    ./minizip-ng-4.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "include(Package)" ""

    substituteInPlace lib/tlCore/CMakeLists.txt \
      --replace-fail "SDL2::SDL2-static" "SDL2::SDL2" \
      --replace-fail "SDL3::SDL3-static" "SDL3::SDL3" \

    substituteInPlace lib/tlIO/CMakeLists.txt \
      --replace-fail \
        "list(APPEND LIBRARIES_PRIVATE libjpeg-turbo::turbojpeg-static)" \
        "list(APPEND LIBRARIES_PRIVATE libjpeg-turbo::jpeg libjpeg-turbo::turbojpeg)"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    bzip2 # required by minizip-ng
    feather-tk
    freetype # required by feather-tk
    glfw
    libGL
    lunasvg # required by feather-tk
    imath
    minizip-ng
    nativefiledialog-extended
    nlohmann_json
    openssl # required by minizip-ng
    opentimelineio
    plutovg # required by feather-tk -> lunasvg
    xz # libLZMA, required by minizip-ng
    zlib # required by minizip-ng
    zstd # required by minizip-ng
  ]
  ++ lib.optionals enableNet [ opencolorio ]
  ++ lib.optionals enableSdl2 [ SDL2 ]
  ++ lib.optionals enableSdl3 [ sdl3 ]
  ++ lib.optionals enableJpeg [ libjpeg ]
  ++ lib.optionals enableTiff [ libtiff ]
  ++ lib.optionals enablePng [ libpng ]
  ++ lib.optionals enableOpenexr [ openexr ]
  ++ lib.optionals enableFfmpeg [ ffmpeg ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" enableShared)
    (lib.cmakeBool "TLRENDER_OCIO" enableNet)
    (lib.cmakeBool "TLRENDER_SDL2" enableSdl2)
    (lib.cmakeBool "TLRENDER_SDL3" enableSdl3)
    (lib.cmakeBool "TLRENDER_JPEG" enableJpeg)
    (lib.cmakeBool "TLRENDER_TIFF" enableTiff)
    (lib.cmakeBool "TLRENDER_STB" enableStb)
    (lib.cmakeBool "TLRENDER_PNG" enablePng)
    (lib.cmakeBool "TLRENDER_EXR" enableOpenexr)
    (lib.cmakeBool "TLRENDER_FFMPEG" enableFfmpeg)
  ];

  # doCheck = enableTests;
  #
  # nativeCheckInputs = lib.optionals (enableTests && stdenv.isLinux) [
  #   xorg.xvfb-run
  # ];
  #
  # checkPhase = lib.optionalString enableTests ''
  #   runHook preCheck
  #
  #   cd feather-tk/src/feather-tk-build
  #   ${if stdenv.isLinux then "xvfb-run" else ""} ctest --verbose -C Release
  #
  #   runHook postCheck
  # '';

  meta = {
    description = "Lightweight toolkit for building cross-platform applications";
    homepage = "https://github.com/darbyjohnston/feather-tk";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
