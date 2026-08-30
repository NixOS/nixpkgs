{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  wrapGAppsHook3,
  gitUpdater,

  cairo,
  ffmpeg,
  gettext,
  glibmm,
  libmng,
  gtk3,
  gtkmm3,
  libjack2,
  libsigcxx,
  libxmlxx,
  mlt,
  imagemagick,
  intltool,
  adwaita-icon-theme,
  harfbuzz,
  freetype,
  fontconfig,
  fribidi,
  openexr,
  fftw,
}:

let
  version = "1.5.5";
  src = fetchFromGitHub {
    owner = "synfig";
    repo = "synfig";
    rev = "v${version}";
    hash = "sha256-5jVd+YqHVHKkePXBb3zjXEVlgdlU6Yb6LC4CurvsBtE=";
  };

  ETL = stdenv.mkDerivation (finalAttrs: {
    pname = "ETL";
    inherit version src;

    sourceRoot = "${src.name}/ETL";

    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [
      pkg-config
      autoreconfHook
    ];
  });

  synfig = stdenv.mkDerivation (finalAttrs: {
    pname = "synfig";
    inherit version src;

    sourceRoot = "${src.name}/synfig-core";

    __structuredAttrs = true;
    strictDeps = true;

    configureFlags = lib.optionals stdenv.cc.isClang [
      # Newer versions of clang default to C++17, but synfig and some of its dependencies use deprecated APIs that
      # are removed in C++17. Setting the language version to C++14 allows it to build.
      "CXXFLAGS=-std=c++14"
    ];

    enableParallelBuilding = true;

    nativeBuildInputs = [
      pkg-config
      autoreconfHook
      gettext
      intltool
      imagemagick
    ];
    buildInputs = [
      ETL
      glibmm
      mlt
      libsigcxx
      libxmlxx
      imagemagick
      harfbuzz
      freetype
      fontconfig
      fribidi
      openexr
      fftw
      ffmpeg
      libmng
    ];
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "synfigstudio";
  inherit version src;

  sourceRoot = "${src.name}/synfig-studio";

  __structuredAttrs = true;
  strictDeps = true;

  postPatch = ''
    patchShebangs images/splash_screen_development.sh
  '';

  preConfigure = ''
    ./bootstrap.sh
  '';

  configureFlags = lib.optionals stdenv.cc.isClang [
    # Newer versions of clang default to C++17, but synfig and some of its dependencies use deprecated APIs that
    # are removed in C++17. Setting the language version to C++14 allows it to build.
    "CXXFLAGS=-std=c++14"
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    gettext
    intltool
    wrapGAppsHook3
    synfig
  ];
  buildInputs = [
    ETL
    synfig
    cairo
    glibmm
    gtk3
    gtkmm3
    imagemagick
    libjack2
    libsigcxx
    libxmlxx
    mlt
    fontconfig
    ffmpeg
    adwaita-icon-theme
    openexr
    fftw
  ];

  enableParallelBuilding = true;

  passthru = {
    # Expose libraries and cli tools
    inherit ETL synfig;

    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "2D animation program";
    homepage = "https://www.synfig.org";
    changelog = "https://github.com/synfig/synfig/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "synfigstudio";
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
