{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  wrapGAppsHook3,

  boost,
  cairo,
  gettext,
  glibmm,
  gtk3,
  gtkmm3,
  libjack2,
  libsigcxx,
  libxmlxx,
  mlt,
  pango,
  imagemagick,
  intltool,
  adwaita-icon-theme,
  harfbuzz,
  freetype,
  fribidi,
  openexr,
  fftw,
}:

let
  version = "1.5.3";
  src = fetchFromGitHub {
    owner = "synfig";
    repo = "synfig";
    rev = "v${version}";
    hash = "sha256-D+FUEyzJ74l0USq3V9HIRAfgyJfRP372aEKDqF8+hsQ=";
  };

  ETL = stdenv.mkDerivation {
    pname = "ETL";
    inherit version src;

    sourceRoot = "${src.name}/ETL";

    nativeBuildInputs = [
      pkg-config
      autoreconfHook
    ];
    buildInputs = [
      glibmm
    ];
  };

  synfig = stdenv.mkDerivation {
    pname = "synfig";
    inherit version src;

    sourceRoot = "${src.name}/synfig-core";

    configureFlags = [
      "--with-boost=${boost.dev}"
      "--with-boost-libdir=${boost.out}/lib"
    ]
    ++ lib.optionals stdenv.cc.isClang [
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
    ];
    buildInputs = [
      ETL
      boost
      cairo
      glibmm
      mlt
      libsigcxx
      libxmlxx
      pango
      imagemagick
      harfbuzz
      freetype
      fribidi
      openexr
      fftw
    ];
  };
in
stdenv.mkDerivation {
  pname = "synfigstudio";
  inherit version src;

  sourceRoot = "${src.name}/synfig-studio";

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
  ];
  buildInputs = [
    ETL
    synfig
    boost
    cairo
    glibmm
    gtk3
    gtkmm3
    imagemagick
    libjack2
    libsigcxx
    libxmlxx
    mlt
    adwaita-icon-theme
    openexr
    fftw
  ];

  enableParallelBuilding = true;

  passthru = {
    # Expose libraries and cli tools
    inherit ETL synfig;
  };

  meta = with lib; {
    description = "2D animation program";
    homepage = "https://www.synfig.org";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
