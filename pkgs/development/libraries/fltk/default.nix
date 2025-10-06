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

  withDocs ? true,
  doxygen,
  graphviz,

  withXorg ? stdenv.hostPlatform.isLinux,

  withExamples ? (stdenv.buildPlatform == stdenv.hostPlatform),
  withShared ? true,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fltk";
  version = "1.3.11";

  src = fetchFromGitHub {
    owner = "fltk";
    repo = "fltk";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-aN0WdHDjxb9O4OgTfBncIj12tRYfeltKev6pgSMu6/E=";
  };

  outputs = [ "out" ] ++ lib.optional withExamples "bin" ++ lib.optional withDocs "doc";

  # Manually move example & test binaries to $bin to avoid cyclic dependencies on dev binaries
  outputBin = lib.optionalString withExamples "out";

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    ./nsosv.patch
  ];

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
  ++ lib.optionals withCairo [
    cairo
  ];

  cmakeFlags = [
    # Common
    (lib.cmakeBool "OPTION_BUILD_SHARED_LIBS" withShared)
    (lib.cmakeBool "OPTION_USE_SYSTEM_ZLIB" true)
    (lib.cmakeBool "OPTION_USE_SYSTEM_LIBJPEG" true)
    (lib.cmakeBool "OPTION_USE_SYSTEM_LIBPNG" true)

    # X11
    (lib.cmakeBool "OPTION_USE_XINERAMA" withXorg)
    (lib.cmakeBool "OPTION_USE_XFIXES" withXorg)
    (lib.cmakeBool "OPTION_USE_XCURSOR" withXorg)
    (lib.cmakeBool "OPTION_USE_XFT" withXorg)
    (lib.cmakeBool "OPTION_USE_XRENDER" withXorg)
    (lib.cmakeBool "OPTION_USE_XDBE" withXorg)

    # GL
    (lib.cmakeBool "OPTION_USE_GL" withGL)
    "-DOpenGL_GL_PREFERENCE=GLVND"

    # Cairo
    (lib.cmakeBool "OPTION_CAIRO" withCairo)
    (lib.cmakeBool "OPTION_CAIROEXT" withCairo)

    # Examples & Tests
    (lib.cmakeBool "FLTK_BUILD_EXAMPLES" withExamples)
    (lib.cmakeBool "FLTK_BUILD_TEST" withExamples)

    # Docs
    (lib.cmakeBool "OPTION_BUILD_HTML_DOCUMENTATION" withDocs)
    (lib.cmakeBool "OPTION_INSTALL_HTML_DOCUMENTATION" withDocs)
    (lib.cmakeBool "OPTION_INCLUDE_DRIVER_DOCUMENTATION" withDocs)
    (lib.cmakeBool "OPTION_BUILD_PDF_DOCUMENTATION" false)
    (lib.cmakeBool "OPTION_INSTALL_PDF_DOCUMENTATION" false)

    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
  ];

  preBuild = lib.optionalString (withCairo && withShared && stdenv.hostPlatform.isDarwin) ''
    # unresolved symbols in cairo dylib without this: https://github.com/fltk/fltk/issues/250
    export NIX_LDFLAGS="$NIX_LDFLAGS -undefined dynamic_lookup"
  '';

  postBuild = lib.optionalString withDocs ''
    make docs
  '';

  postInstall =
    lib.optionalString withExamples ''
      mkdir -p $bin/bin
      mv bin/{test,examples}/* $bin/bin/
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Library/Frameworks
      mv $out{,/Library/Frameworks}/FLTK.framework

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

      rm $out/bin/fluid.icns
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
      "release-(1\\.3\\.[0-9.]+)"
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
