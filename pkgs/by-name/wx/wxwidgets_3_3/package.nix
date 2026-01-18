{
  lib,
  stdenv,
  curl,
  expat,
  fetchFromGitHub,
  gspell,
  gst_all_1,
  gtk3,
  libGL,
  libGLU,
  libSM,
  libXinerama,
  libXtst,
  libXxf86vm,
  libnotify,
  libpng,
  libsecret,
  libtiff,
  libjpeg_turbo,
  libxkbcommon,
  zlib,
  pcre2,
  pkg-config,
  xorgproto,
  compat30 ? false,
  compat32 ? true,
  withMesa ? !stdenv.hostPlatform.isDarwin,
  withWebKit ? true,
  webkitgtk_4_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wxwidgets";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "wxWidgets";
    repo = "wxWidgets";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-eYmZrh9lvDnJ3VAS+TllT21emtKBPAOhqIULw1dTPhk=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    libpng
    libtiff
    libjpeg_turbo
    zlib
    pcre2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    curl
    gspell # wxTextCtrl spell checking
    gtk3
    libSM
    libXinerama
    libXtst
    libXxf86vm
    libnotify # wxNotificationMessage backend
    libsecret # wxSecretStore backend
    libxkbcommon # proper key codes in key events
    xorgproto
  ]
  ++ lib.optional withMesa libGLU
  ++ lib.optional (withWebKit && stdenv.hostPlatform.isLinux) webkitgtk_4_1
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    expat
  ];

  configureFlags = [
    "--disable-precomp-headers"
    # This is the default option, but be explicit
    "--disable-monolithic"
    "--enable-mediactrl"
    "--with-nanosvg"
    "--disable-rpath"
    "--enable-repro-build"
    "--enable-webrequest"
    (if compat30 then "--enable-compat30" else "--disable-compat30")
    (if compat32 then "--enable-compat32" else "--disable-compat32")
  ]
  ++ lib.optional withMesa "--with-opengl"
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--with-macosx-version-min=${stdenv.hostPlatform.darwinMinVersion}"
    "--with-osx_cocoa"
    "--with-libiconv"
    "--with-urlsession" # for wxWebRequest
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "--with-libcurl" # for wxWebRequest
  ]
  ++ lib.optionals withWebKit [
    "--enable-webview"
    "--enable-webviewwebkit"
  ];

  SEARCH_LIB = lib.optionalString (
    !stdenv.hostPlatform.isDarwin
  ) "${libGLU.out}/lib ${libGL.out}/lib";

  postInstall = "
    pushd $out/include
    ln -s wx-*/* .
    popd
  ";

  enableParallelBuilding = true;

  passthru = {
    inherit compat30 compat32;
  };

  meta = {
    homepage = "https://www.wxwidgets.org/";
    description = "Cross-Platform C++ GUI Library";
    longDescription = ''
      wxWidgets gives you a single, easy-to-use API for writing GUI applications
      on multiple platforms that still utilize the native platform's controls
      and utilities. Link with the appropriate library for your platform and
      compiler, and your application will adopt the look and feel appropriate to
      that platform. On top of great GUI functionality, wxWidgets gives you:
      online help, network programming, streams, clipboard and drag and drop,
      multithreading, image loading and saving in a variety of popular formats,
      database support, HTML viewing and printing, and much more.
    '';
    license = with lib.licenses; [
      lgpl2Plus
      wxWindowsException31
    ];
    maintainers = with lib.maintainers; [
      fliegendewurst
      wegank
    ];
    platforms = lib.platforms.unix;
  };
})
