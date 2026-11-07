{
  lib,
  stdenv,
  fetchFromGitHub,
  gst_all_1,
  gtk3,
  libGL,
  libGLU,
  libsm,
  libxinerama,
  libxtst,
  libxxf86vm,
  pkg-config,
  xorgproto,
  libpng,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wxwidgets";
  version = "3.1.4-unstable-2022-02-11";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "prusa3d";
    repo = "wxWidgets";
    rev = "489f6118256853cf5b299d595868641938566cdb";
    hash = "sha256-xGL5I2+bPjmZGSTYe1L7VAmvLHbwd934o/cxg9baEvQ=";
    fetchSubmodules = true;
  };

  patches = [ ./0001-fix-assertion-using-hide-in-destroy.patch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    gtk3
    libsm
    libxinerama
    libxtst
    libxxf86vm
    xorgproto
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) libGLU
  ++ lib.optional stdenv.hostPlatform.isDarwin libpng;

  configureFlags = [
    "--disable-precomp-headers"
    # This is the default option, but be explicit
    "--disable-monolithic"
    "--enable-mediactrl"
    "--disable-compat28"
    "--enable-compat30"
  ]
  ++ [ "--enable-unicode" ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) "--with-opengl"
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--with-macosx-version-min=${stdenv.hostPlatform.darwinMinVersion}"
    "--with-osx_cocoa"
    "--with-libiconv"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--enable-webview"
    "--enable-webviewwebkit"
  ];

  env = lib.optionalAttrs (!stdenv.hostPlatform.isDarwin) {
    SEARCH_LIB = toString [
      "${libGLU.out}/lib"
      "${libGL.out}/lib"
    ];
  };

  preConfigure = ''
    substituteInPlace configure --replace \
      'SEARCH_INCLUDE=' 'DUMMY_SEARCH_INCLUDE='
    substituteInPlace configure --replace \
      'SEARCH_LIB=' 'DUMMY_SEARCH_LIB='
    substituteInPlace configure --replace \
      /usr /no-such-path
  '';

  postInstall = "
    pushd $out/include
    ln -s wx-*/* .
    popd
  ";

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/prusa3d/wxWidgets";
    description = "Cross-Platform C++ GUI Library with Prusa patches";
    longDescription = ''
      wxWidgets gives you a single, easy-to-use API for writing GUI applications
      on multiple platforms that still utilize the native platform's controls
      and utilities. Link with the appropriate library for your platform and
      compiler, and your application will adopt the look and feel appropriate to
      that platform. On top of great GUI functionality, wxWidgets gives you:
      online help, network programming, streams, clipboard and drag and drop,
      multithreading, image loading and saving in a variety of popular formats,
      database support, HTML viewing and printing, and much more.

      This package includes patches made by Prusa to support Prusa Slicer.
    '';
    license = with lib.licenses; WITH lgpl2Plus wxWindowsException31;
    platforms = lib.platforms.unix;
  };
})
