{
  cmake,
  fetchFromGitHub,
  ffmpeg,
  graphicsmagick,
  lib,
  libdeflate,
  libexif,
  libjpeg,
  libsixel,
  openslide,
  poppler,
  librsvg,
  cairo,
  pkg-config,
  stb,
  qoi,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "timg";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "timg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UiQ8CW0mxjjQM6XLN0FL2v7ccYq2EmIy/3pm+yKQh8w=";
  };

  buildInputs = [
    ffmpeg
    graphicsmagick
    libdeflate
    libexif
    libjpeg
    libsixel
    openslide
    poppler
    librsvg
    cairo
    qoi.dev
    stb
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DTIMG_VERSION_FROM_GIT=Off"
    "-DWITH_VIDEO_DECODING=On"
    "-DWITH_VIDEO_DEVICE=On"
    "-DWITH_OPENSLIDE_SUPPORT=On"
    "-DWITH_LIBSIXEL=On"
  ];

  meta = {
    description = "Terminal image and video viewer";
    homepage = "https://timg.sh/";
    license = lib.licenses.gpl2Only;
    mainProgram = "timg";
    maintainers = with lib.maintainers; [ hzeller ];
    platforms = lib.platforms.unix;
  };
})
