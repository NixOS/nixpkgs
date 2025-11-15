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
  nasm,
  nativefiledialog-extended,
  nlohmann_json,
  opencolorio,
  openexr,
  openimageio,
  openssl,
  opentimelineio,
  openusd,
  plutovg,
  SDL2,
  sdl3,
  xz,
  zlib,
  zstd,

  # optional dependencies
  enableNet ? false,
  enableOcio ? true,
  enableSdl2 ? true,
  enableSdl3 ? false,
  enableJpeg ? true,
  enableTiff ? true,
  enableStb ? true,
  enablePng ? true,
  enableOpenexr ? true,
  enableFfmpeg ? true,
  enableUsd ? false,
  enableOiio ? true,

  # build options
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableProgram ? true,
  enableExamples ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tlrender";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "darbyjohnston";
    repo = "tlRender";
    tag = finalAttrs.version;
    hash = "sha256-QKISrGc72Bb139LNLtrhAs8FQbFLRp0iEJw7TMxSuPk=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "include(Package)" ""

    substituteInPlace lib/tlCore/CMakeLists.txt \
      --replace-fail "SDL2::SDL2-static" "SDL2::SDL2" \
      --replace-fail "SDL3::SDL3-static" "SDL3::SDL3" \
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
    openimageio
    plutovg # required by feather-tk -> lunasvg
    xz # libLZMA, required by minizip-ng
    zlib # required by minizip-ng
    zstd # required by minizip-ng
  ]
  ++ lib.optionals enableNet [ nasm ]
  ++ lib.optionals enableOcio [ opencolorio ]
  ++ lib.optionals enableOiio [ openimageio ]
  ++ lib.optionals enableSdl2 [ SDL2 ]
  ++ lib.optionals enableSdl3 [ sdl3 ]
  ++ lib.optionals enableJpeg [ libjpeg ]
  ++ lib.optionals enableTiff [ libtiff ]
  ++ lib.optionals enablePng [ libpng ]
  ++ lib.optionals enableOpenexr [ openexr ]
  ++ lib.optionals enableFfmpeg [ ffmpeg ]
  ++ lib.optionals enableUsd [ openusd ];

  cmakeFlags = [
    (lib.cmakeBool "TLRENDER_NET" enableNet)
    (lib.cmakeBool "TLRENDER_OCIO" enableOcio)
    (lib.cmakeBool "TLRENDER_OIIO" enableOiio)
    (lib.cmakeBool "TLRENDER_SDL2" enableSdl2)
    (lib.cmakeBool "TLRENDER_SDL3" enableSdl3)
    (lib.cmakeBool "TLRENDER_JPEG" enableJpeg)
    (lib.cmakeBool "TLRENDER_TIFF" enableTiff)
    (lib.cmakeBool "TLRENDER_STB" enableStb)
    (lib.cmakeBool "TLRENDER_PNG" enablePng)
    (lib.cmakeBool "TLRENDER_EXR" enableOpenexr)
    (lib.cmakeBool "TLRENDER_FFMPEG" enableFfmpeg)
    (lib.cmakeBool "TLRENDER_USD" enableUsd)

    (lib.cmakeBool "BUILD_SHARED_LIBS" enableShared)
    (lib.cmakeBool "TLRENDER_PROGRAMS" enableProgram)
    (lib.cmakeBool "TLRENDER_EXAMPLES" enableExamples)
    (lib.cmakeBool "TLRENDER_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  # GLFW requires a working X11 session.
  doCheck = false;

  meta = {
    description = "Open source library for building playback and review applications";
    longDescription = ''
      An open source library for building playback and review applications for
      visual effects, film, and animation.

      The library can render and playback timelines with multiple video clips,
      image sequences, audio clips, and transitions. Examples are provided for
      integrating the library with Qt and OpenGL applications.
    '';
    homepage = "https://github.com/darbyjohnston/tlRender";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ yzx9 ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
