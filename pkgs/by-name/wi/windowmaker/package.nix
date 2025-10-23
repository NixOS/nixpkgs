{
  lib,
  stdenv,
  fetchFromRepoOrCz,
  autoreconfHook,
  callPackage,
  pkg-config,
  imagemagick,
  libX11,
  libXext,
  libXft,
  libXinerama,
  libXmu,
  libXpm,
  libXrandr,
  libXres,
  libexif,
  libjpeg,
  libpng,
  libtiff,
  giflib,
  libwebp,
  pango,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "windowmaker";
  version = "0.96.0";

  src = fetchFromRepoOrCz {
    repo = "wmaker-crm";
    rev = "wmaker-${finalAttrs.version}";
    hash = "sha256-6DS5KztCNWPQL6/qJ5vlkOup2ourxSNf6LLTFYpPWi8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    giflib
    imagemagick
    libX11
    libXext
    libXft
    libXinerama
    libXmu
    libXpm
    libXrandr
    libXres
    libexif
    libjpeg
    libpng
    libtiff
    libwebp
    pango
  ];

  configureFlags = [
    "--enable-modelock"
    "--enable-randr"
    "--enable-webp"
    "--with-x"
  ];

  passthru = {
    dockapps = callPackage ./dockapps { };
  };

  meta = {
    homepage = "http://windowmaker.org/";
    description = "NeXTSTEP-like window manager";
    longDescription = ''
      Window Maker is an X11 window manager originally designed to provide
      integration support for the GNUstep Desktop Environment. In every way
      possible, it reproduces the elegant look and feel of the NEXTSTEP user
      interface. It is fast, feature rich, easy to configure, and easy to
      use. It is also free software, with contributions being made by
      programmers from around the world.
    '';
    changelog = "https://www.windowmaker.org/news/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "wmaker";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
