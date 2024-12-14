{ lib
, stdenv
, curl
, expat
, fetchFromGitHub
, gst_all_1
, gtk3
, libGL
, libGLU
, libSM
, libXinerama
, libXtst
, libXxf86vm
, libpng
, libtiff
, libjpeg_turbo
, zlib
, pcre2
, pkg-config
, xorgproto
, compat28 ? false
, compat30 ? true
, unicode ? true
, withMesa ? !stdenv.hostPlatform.isDarwin
, withWebKit ? true
, webkitgtk_4_0
, setfile
, AGL
, Carbon
, Cocoa
, Kernel
, QTKit
, AVFoundation
, AVKit
, WebKit
}:
let
  catch = fetchFromGitHub {
    owner = "wxWidgets";
    repo = "Catch";
    rev = "5f5e4cecd1cafc85e109471356dec29e778d2160";
    hash = "sha256-fB/E17tiAicAkq88Je/YFYohJ6EHJOO54oQaqiR/OzY=";
  };

  nanosvg = fetchFromGitHub {
    owner = "wxWidgets";
    repo = "nanosvg";
    rev = "ccdb1995134d340a93fb20e3a3d323ccb3838dd0";
    hash = "sha256-ymziU0NgGqxPOKHwGm0QyEdK/8jL/QYk5UdIQ3Tn8jw=";
  };
in
stdenv.mkDerivation rec {
  pname = "wxwidgets";
  version = "3.2.6";

  src = fetchFromGitHub {
    owner = "wxWidgets";
    repo = "wxWidgets";
    rev = "v${version}";
    hash = "sha256-7dc7NGiKSonFFaWp3UxLYqDc1Cc6no1Eba0QmtzX5mM=";
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
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    curl
    gtk3
    libSM
    libXinerama
    libXtst
    libXxf86vm
    xorgproto
  ]
  ++ lib.optional withMesa libGLU
  ++ lib.optional (withWebKit && stdenv.hostPlatform.isLinux) webkitgtk_4_0
  ++ lib.optional (withWebKit && stdenv.hostPlatform.isDarwin) WebKit
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    expat
    setfile
    Carbon
    Cocoa
    Kernel
    QTKit
    AVFoundation
    AVKit
    WebKit
  ];

  propagatedBuildInputs = lib.optional stdenv.hostPlatform.isDarwin AGL;

  configureFlags = [
    "--disable-precomp-headers"
    # This is the default option, but be explicit
    "--disable-monolithic"
    "--enable-mediactrl"
    "--with-nanosvg"
    "--disable-rpath"
    "--enable-repro-build"
    "--enable-webrequest"
    (if compat28 then "--enable-compat28" else "--disable-compat28")
    (if compat30 then "--enable-compat30" else "--disable-compat30")
  ] ++ lib.optional unicode "--enable-unicode"
  ++ lib.optional withMesa "--with-opengl"
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--with-osx_cocoa"
    "--with-libiconv"
    "--with-urlsession" # for wxWebRequest
  ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "--with-libcurl" # for wxWebRequest
  ] ++ lib.optionals withWebKit [
    "--enable-webview"
    "--enable-webviewwebkit"
  ];

  SEARCH_LIB = lib.optionalString (!stdenv.hostPlatform.isDarwin) "${libGLU.out}/lib ${libGL.out}/lib";

  preConfigure = ''
    cp -r ${catch}/* 3rdparty/catch/
    cp -r ${nanosvg}/* 3rdparty/nanosvg/
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace configure \
      --replace 'ac_cv_prog_SETFILE="/Developer/Tools/SetFile"' 'ac_cv_prog_SETFILE="${setfile}/bin/SetFile"'
    substituteInPlace configure \
      --replace "-framework System" "-lSystem"
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
    license = licenses.wxWindows;
    maintainers = with maintainers; [ tfmoraes ];
    platforms = platforms.unix;
  };
}
