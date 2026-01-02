{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  zlib,
  libjpeg,
  libpng,
  fontconfig,
  freetype,
  libX11,
  libXext,
  libXinerama,
  libXfixes,
  libXcursor,
  libXft,
  libXrender,

  withGL ? true,
  libGL,
  libGLU,
  glew,

  withCairo ? true,
  cairo,

  # pango depends on Xft, and implicitly enables cairo.
  # So only enable pango if cairo is enabled too.
  withPango ? withXorg && withCairo,
  pango,

  withDocs ? true,
  doxygen,
  graphviz,

  withXorg ? stdenv.hostPlatform.isLinux,

  withWayland ? stdenv.hostPlatform.isLinux && withCairo,
  wayland,
  wayland-protocols,
  libxkbcommon,
  wayland-scanner,
  libdecor,

  withExamples ? (stdenv.buildPlatform == stdenv.hostPlatform),

  nix-update-script,
}:

# pango support depends on Xft
assert withPango -> withXorg;

# wayland support depends on cairo
assert withWayland -> withCairo;

stdenv.mkDerivation (finalAttrs: {
  pname = "fltk";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "fltk";
    repo = "fltk";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-xba9uiiwQhM4a3Rf4PoGshY3mUKZrcsm+Iv7qnE2sEA=";
  };

  outputs = [ "out" ] ++ lib.optional withExamples "bin" ++ lib.optional withDocs "doc";

  # Manually move example & test binaries to $bin to avoid cyclic dependencies on dev binaries
  outputBin = lib.optionalString withExamples "out";

  postPatch = ''
    patchShebangs documentation/make_*
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals withWayland [
    wayland-scanner
  ]
  ++ lib.optionals withDocs [
    doxygen
    graphviz
  ];

  buildInputs =
    lib.optionals (withGL && !stdenv.hostPlatform.isDarwin) [
      libGL
      libGLU
    ]
    ++ lib.optionals (withExamples && withGL) [
      glew
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      fontconfig
    ];

  propagatedBuildInputs = [
    zlib
    libjpeg
    libpng
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    freetype
  ]
  ++ lib.optionals withXorg [
    libX11
    libXext
    libXinerama
    libXfixes
    libXcursor
    libXft
    libXrender
  ]
  ++ lib.optionals withWayland [
    wayland
    wayland-protocols
    libxkbcommon
    libdecor
  ]
  ++ lib.optionals withCairo [
    cairo
  ]
  ++ lib.optionals withPango [
    pango
  ];

  cmakeFlags = [
    # Common
    (lib.cmakeBool "FLTK_BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "FLTK_USE_SYSTEM_LIBDECOR" true)
    (lib.cmakeBool "FLTK_USE_SYSTEM_LIBJPEG" true)
    (lib.cmakeBool "FLTK_USE_SYSTEM_LIBPNG" true)
    (lib.cmakeBool "FLTK_USE_SYSTEM_ZLIB" true)

    # X11
    (lib.cmakeBool "FLTK_USE_XINERAMA" withXorg)
    (lib.cmakeBool "FLTK_USE_XFIXES" withXorg)
    (lib.cmakeBool "FLTK_USE_XCURSOR" withXorg)
    (lib.cmakeBool "FLTK_USE_XFT" withXorg)
    (lib.cmakeBool "FLTK_USE_XRENDER" withXorg)

    # Wayland
    (lib.cmakeBool "FLTK_BACKEND_WAYLAND" withWayland)

    # GL
    (lib.cmakeBool "FLTK_BUILD_GL" withGL)

    # Cairo
    (lib.cmakeBool "FLTK_OPTION_CAIRO_WINDOW" withCairo)
    (lib.cmakeBool "FLTK_OPTION_CAIRO_EXT" withCairo)

    # Pango
    (lib.cmakeBool "FLTK_USE_PANGO" withPango)

    # Examples & Tests
    (lib.cmakeBool "FLTK_BUILD_EXAMPLES" withExamples)
    (lib.cmakeBool "FLTK_BUILD_TEST" withExamples)

    # Docs
    (lib.cmakeBool "FLTK_BUILD_HTML_DOCS" withDocs)
    (lib.cmakeBool "FLTK_INSTALL_HTML_DOCS" withDocs)
    (lib.cmakeBool "FLTK_INCLUDE_DRIVER_DOCS" withDocs)
    (lib.cmakeBool "FLTK_BUILD_PDF_DOCS" false)
    (lib.cmakeBool "FLTK_INSTALL_PDF_DOCS" false)

    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
  ];

  postBuild = lib.optionalString withDocs ''
    make docs
  '';

  postInstall =
    lib.optionalString withExamples ''
      mkdir -p $bin/bin
      mv bin/{test,examples}/* $bin/bin/
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      moveAppBundles() {
        echo "Moving and symlinking $1"
        appname="$(basename "$1")"
        binname="$(basename "$(find "$1"/Contents/MacOS/ -type f -executable | head -n1)")"
        curpath="$(dirname "$1")"

        mkdir -p "$curpath"/../Applications/
        mv "$1" "$curpath"/../Applications/
        [ -f "$curpath"/"$binname" ] && rm "$curpath"/"$binname"
        ln -s ../Applications/"$appname"/Contents/MacOS/"$binname" "$curpath"/"$binname"
      }

      for app in $out/bin/*.app ${lib.optionalString withExamples "$bin/bin/*.app"}; do
        moveAppBundles "$app"
      done
    '';

  postFixup = ''
    substituteInPlace $out/bin/fltk-config \
      --replace-fail "/$out/" "/"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "release-(1\\.4\\.[0-9.]+)"
    ];
  };

  meta = {
    description = "C++ cross-platform lightweight GUI library";
    homepage = "https://www.fltk.org";
    platforms = lib.platforms.unix;
    # LGPL2 with static linking exception
    # https://www.fltk.org/COPYING.php
    license = lib.licenses.lgpl2Only;
  };
})
