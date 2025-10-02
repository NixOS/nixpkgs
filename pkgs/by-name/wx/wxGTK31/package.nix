{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
  gst_all_1,
  gtk3,
  libGL,
  libGLU,
  libSM,
  libXinerama,
  libXtst,
  libXxf86vm,
  pkg-config,
  xorgproto,
  compat28 ? false,
  compat30 ? true,
  unicode ? true,
  withCurl ? false,
  withPrivateFonts ? false,
  withEGL ? true,
  withMesa ? !stdenv.hostPlatform.isDarwin,
  withWebKit ? stdenv.hostPlatform.isDarwin,
  webkitgtk_4_1,
  libpng,
}:

stdenv.mkDerivation rec {
  pname = "wxwidgets";
  version = "3.1.7";

  src = fetchFromGitHub {
    owner = "wxWidgets";
    repo = "wxWidgets";
    tag = "v${version}";
    hash = "sha256-9qYPatpTT28H+fz77o7/Y3YVmiK0OCsiQT5QAYe93M0=";
    fetchSubmodules = true;
  };

  patches = [
    # https://github.com/wxWidgets/wxWidgets/issues/17942
    ./0001-fix-assertion-using-hide-in-destroy.patch
    # Add support for libwebkit2gtk-4.1 and libsoup-3.0, cherry-picked from
    # https://github.com/SoftFever/Orca-deps-wxWidgets/commit/1b8664426603376b68f8ca3c54de97ec630e5940
    ./0002-support-webkitgtk-41.patch
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    gtk3
    libSM
    libXinerama
    libXtst
    libXxf86vm
    xorgproto
  ]
  ++ lib.optional withCurl curl
  ++ lib.optional withMesa libGLU
  ++ lib.optional (withWebKit && !stdenv.hostPlatform.isDarwin) webkitgtk_4_1
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libpng
  ];

  configureFlags = [
    "--disable-precomp-headers"
    # This is the default option, but be explicit
    "--disable-monolithic"
    "--enable-mediactrl"
    (if compat28 then "--enable-compat28" else "--disable-compat28")
    (if compat30 then "--enable-compat30" else "--disable-compat30")
  ]
  ++ lib.optional (!withEGL) "--disable-glcanvasegl"
  ++ lib.optional unicode "--enable-unicode"
  ++ lib.optional withCurl "--enable-webrequest"
  ++ lib.optional withPrivateFonts "--enable-privatefonts"
  ++ lib.optional withMesa "--with-opengl"
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--with-osx_cocoa"
    "--with-libiconv"
  ]
  ++ lib.optionals withWebKit [
    "--enable-webview"
    "--enable-webviewwebkit"
  ];

  SEARCH_LIB = lib.optionalString (
    !stdenv.hostPlatform.isDarwin
  ) "${libGLU.out}/lib ${libGL.out}/lib ";

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

  passthru = {
    inherit compat28 compat30 unicode;
  };

  meta = with lib; {
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
    license = with licenses; [
      lgpl2Plus
      wxWindowsException31
    ];
    platforms = platforms.unix;
  };
}
