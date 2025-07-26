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
stdenv.mkDerivation (finalAttrs: {
  pname = "wuimg";
  version = "1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "kaleido";
    repo = "wuimg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dPcfgp1RZ6TlyaO+qjcFM7fZlX1bUJcYhb2Nn05tASQ=";
  };

  mesonFlags =
    lib.optionals (!withX11) [ "-Dwindow_glfw=disabled" ]
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

  buildInputs =
    [
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

  buildPhase = ''
    runHook preBuild

    meson compile
    meson compile wuconv

    runHook postBuild
  '';

  postInstall = ''
    install -Dm755 src/wuconv $out/bin
  '';

  meta = with lib; {
    description = "Minimalistic but not barebones image viewer";
    homepage = "https://codeberg.org/kaleido/wuimg";
    license = licenses.bsd0;
    maintainers = with maintainers; [ _2goodAP ];
    platforms = platforms.linux;
    mainProgram = "wu";
    longDescription = ''
      wu is a minimalistic but not barebones image viewer. It aims for comfort,
      speed, accurate color rendering, and format documentation/preservation.
      wu is meant as a terminal companion, so launching from one is recommended.
    '';
  };
})
