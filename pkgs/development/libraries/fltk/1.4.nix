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

  withPango ? stdenv.hostPlatform.isLinux,
  pango,

  withDocs ? true,
  doxygen,
  graphviz,

  withExamples ? (stdenv.buildPlatform == stdenv.hostPlatform),
}:

let
  onOff = value: if value then "ON" else "OFF";
in
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
    libX11
    libXext
    libXinerama
    libXfixes
    libXcursor
    libXft
    libXrender
  ]
  ++ lib.optionals withCairo [
    cairo
  ]
  ++ lib.optionals withPango [
    pango
  ];

  cmakeFlags = [
    # Common
    "-DFLTK_BUILD_SHARED_LIBS=${onOff (!stdenv.hostPlatform.isStatic)}"
    "-DFLTK_USE_SYSTEM_LIBDECOR=ON"
    "-DFLTK_USE_SYSTEM_LIBJPEG=ON"
    "-DFLTK_USE_SYSTEM_LIBPNG=ON"
    "-DFLTK_USE_SYSTEM_ZLIB=ON"

    # X11
    "-DFLTK_USE_XINERAMA=${onOff stdenv.hostPlatform.isLinux}"
    "-DFLTK_USE_XFIXES=${onOff stdenv.hostPlatform.isLinux}"
    "-DFLTK_USE_XCURSOR=${onOff stdenv.hostPlatform.isLinux}"
    "-DFLTK_USE_XFT=${onOff stdenv.hostPlatform.isLinux}"
    "-DFLTK_USE_XRENDER=${onOff stdenv.hostPlatform.isLinux}"

    # GL
    "-DFLTK_BUILD_GL=${onOff withGL}"
    "-DOpenGL_GL_PREFERENCE=GLVND"

    # Cairo
    "-DFLTK_OPTION_CAIRO_WINDOW=${onOff withCairo}"
    "-DFLTK_OPTION_CAIRO_EXT=${onOff withCairo}"

    # Pango
    "-DFLTK_USE_PANGO=${onOff withPango}"

    # Examples & Tests
    "-DFLTK_BUILD_EXAMPLES=${onOff withExamples}"
    "-DFLTK_BUILD_TEST=${onOff withExamples}"

    # Docs
    "-DFLTK_BUILD_HTML_DOCS=${onOff withDocs}"
    "-DFLTK_BUILD_PDF_DOCS=OFF"
    "-DFLTK_INSTALL_HTML_DOCS=${onOff withDocs}"
    "-DFLTK_INSTALL_PDF_DOCS=OFF"
    "-DFLTK_INCLUDE_DRIVER_DOCS=${onOff withDocs}"

    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
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

  meta = {
    description = "C++ cross-platform lightweight GUI library";
    homepage = "https://www.fltk.org";
    platforms = lib.platforms.unix;
    # LGPL2 with static linking exception
    # https://www.fltk.org/COPYING.php
    license = lib.licenses.lgpl2Only;
  };
})
