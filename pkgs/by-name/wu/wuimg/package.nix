{
  lib,
  stdenv,
  fetchFromGitea,
  meson,
  ninja,
  pkg-config,
  python3,
  wayland-scanner,
  libarchive,
  libepoxy,
  exiv2,
  icu,
  lcms,
  libuchardet,
  wayland,
  libGL,
  libxkbcommon,
  wayland-protocols,
  libdrm,
  libgbm,
  glfw,
  zlib,
  libavif,
  flif,
  giflib,
  libheif,
  jbigkit,
  jbig2dec,
  libjpeg,
  openjpeg,
  charls,
  libjxl,
  lerc,
  libpng,
  libraw,
  librsvg,
  libtiff,
  libwebp,
  withX11 ? false,
  exoticImageFormats ? true,
}:
let
  # Use `ar` with lto support
  ar =
    stdenv.cc.bintools.targetPrefix
    + (
      if stdenv.cc.isClang then
        "llvm-ar"
      else if stdenv.cc.isGNU then
        "gcc-ar"
      else
        "ar"
    );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wuimg";
  version = "1.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "kaleido";
    repo = "wuimg";
    tag = "w${finalAttrs.version}";
    hash = "sha256-9iTHgFOoA/0W6gMlA9hJzrlISogv3/eMa3Rru01mx8E=";
  };

  mesonFlags = [
    # Enable lto
    "-Db_lto=true"
  ]
  ++ lib.optionals (!withX11) [
    # Configure X11 support
    "-Dwindow_glfw=disabled"
  ]
  ++ lib.optionals (!exoticImageFormats) [
    # Disable all external formats
    "-Dauto_features=disabled"
    "-Ddisable_external=true"
    # Except jpeg, png, svg, webp
    "-Djpeg=enabled"
    "-Dpng=enabled"
    "-Dsvg=enabled"
    "-Dwebp=enabled"
    # Also, enable wayland and drm backends
    "-Dwindow_wayland=enabled"
    "-Dwindow_drm=enabled"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    wayland-scanner
  ];

  buildInputs = [
    # Minimum
    libarchive
    libepoxy
    exiv2
    icu
    lcms
    libuchardet

    # Wayland
    wayland
    libGL
    libxkbcommon
    wayland-protocols

    # DRM/KMS
    libdrm
    libgbm

    # Minimal external formats
    libjpeg
    libpng
    librsvg
    libwebp
  ]
  ++ lib.optionals withX11 [ glfw ]
  ++ lib.optionals exoticImageFormats [
    # More exotic external formats
    zlib
    libavif
    flif
    giflib
    libheif
    jbigkit
    jbig2dec
    openjpeg
    charls
    libjxl
    lerc
    libraw
    libtiff
  ];

  preConfigure = ''
    export AR="${ar}"
  '';

  buildPhase = ''
    runHook preBuild

    meson compile
    meson compile wuconv

    runHook postBuild
  '';

  postInstall = ''
    install -Dm755 src/wuconv $out/bin
  '';

  meta = {
    description = "Minimalistic but not barebones image viewer";
    homepage = "https://codeberg.org/kaleido/wuimg";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ leguteape ];
    platforms = lib.platforms.linux;
    mainProgram = "wu";
    longDescription = ''
      wu is a minimalistic but not barebones image viewer. It aims for comfort,
      speed, accurate color rendering, and format documentation/preservation.
      wu is meant as a terminal companion, so launching from one is recommended.
    '';
  };
})
