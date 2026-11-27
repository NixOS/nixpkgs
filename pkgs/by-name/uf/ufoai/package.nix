{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  libtheora,
  xvidcore,
  libGLU,
  libGL,
  SDL2,
  SDL2_ttf,
  SDL2_mixer,
  curl,
  libjpeg,
  libogg,
  libpng,
  libvorbis,
  minixml,
  gettext,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ufoai";
  version = "2.5-unstable-2020-12-24";

  # unstable for fixes needed by current compilers
  src = fetchFromGitHub {
    owner = "ufoaiorg";
    repo = "ufoai";
    rev = "59e97870caaab03960e4ea7d16b2de3c18898c94";
    hash = "sha256-G2icAJs5uldiuIOOuGtzl03bYqexTYi62XCY6D+IT8M=";
  };

  srcData = fetchurl {
    urls = [
      # Gentoo mirrors the same file, SourceForge only serves it slowly
      "mirror://gentoo/distfiles/72/ufoai-2.5-data.tar"
      "mirror://sourceforge/ufoai/ufoai-2.5-data.tar"
    ];
    hash = "sha256-XnBqQkr/ai6jCkx5gSnWME6Jc4fq34CFKBKbUSt9zbA=";
  };

  env = {
    # to avoid occasional runtime error in finding libgcc_s.so.1
    NIX_CFLAGS_LINK = "-lgcc_s";
  };

  preConfigure = ''tar xvf "${finalAttrs.srcData}"'';

  configureFlags = [
    "--enable-release"
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86 [ "--enable-sse" ]
  ++ [
    # upstream's unit tests and memory debugging tool, never run here
    "--disable-testall"
    "--disable-memory"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libtheora
    xvidcore
    libGLU
    libGL
    SDL2
    SDL2_ttf
    SDL2_mixer
    curl
    libjpeg
    libogg
    libpng
    libvorbis
    minixml
    gettext
    zlib
  ];

  enableParallelBuilding = true;

  # the map editor needs GTK 2 and is not built, but its launcher is installed
  postInstall = ''
    rm $out/bin/uforadiant
  '';

  meta = {
    homepage = "http://ufoai.org";
    description = "Squad-based tactical strategy game in the tradition of X-Com";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    hydraPlatforms = [ ];
  };
})
