{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, gnome2
, gst_all_1
, gtk2
, gtk3
, libGL
, libGLU
, libSM
, libXinerama
, libXtst
, libXxf86vm
, pkg-config
, xorgproto
, compat28 ? false
, compat30 ? true
, unicode ? true
, withGtk2 ? (!stdenv.isDarwin)
, withMesa ? lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms
, withWebKit ? stdenv.isDarwin
, webkitgtk
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

assert withGtk2 -> (!withWebKit);

let
  gtk = if withGtk2 then gtk2 else gtk3;
in
stdenv.mkDerivation rec {
  pname = "wxwidgets";
  version = "3.1.5";

  src = fetchFromGitHub {
    owner = "wxWidgets";
    repo = "wxWidgets";
    rev = "v${version}";
    hash = "sha256-2zMvcva0GUDmSYK0Wk3/2Y6R3F7MgdqGBrOhmWgVA6g=";
    fetchSubmodules = true;
  };

  patches = [
    # https://github.com/wxWidgets/wxWidgets/issues/17942
    ./patches/0001-fix-assertion-using-hide-in-destroy.patch
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
  ]
  ++ lib.optionals (!stdenv.isDarwin) [
    gtk
    libSM
    libXinerama
    libXtst
    libXxf86vm
    xorgproto
  ]
  ++ lib.optionals withGtk2 [
    gnome2.GConf
  ]
  ++ lib.optional withMesa libGLU
  ++ lib.optional (withWebKit && !stdenv.isDarwin) webkitgtk
  ++ lib.optional (withWebKit && stdenv.isDarwin) WebKit
  ++ lib.optionals stdenv.isDarwin [
    setfile
    Carbon
    Cocoa
    Kernel
    QTKit
    AVFoundation
    AVKit
    WebKit
  ];

  propagatedBuildInputs = lib.optional stdenv.isDarwin AGL;

  configureFlags = [
    "--disable-precomp-headers"
    # This is the default option, but be explicit
    "--disable-monolithic"
    "--enable-mediactrl"
    (if compat28 then "--enable-compat28" else "--disable-compat28")
    (if compat30 then "--enable-compat30" else "--disable-compat30")
  ]
  ++ lib.optional unicode "--enable-unicode"
  ++ lib.optional withMesa "--with-opengl"
  ++ lib.optionals stdenv.isDarwin [
    "--with-osx_cocoa"
    "--with-libiconv"
  ]
  ++ lib.optionals withWebKit [
    "--enable-webview"
    "--enable-webviewwebkit"
  ];

  SEARCH_LIB = "${libGLU.out}/lib ${libGL.out}/lib ";

  preConfigure = ''
    substituteInPlace configure --replace \
      'SEARCH_INCLUDE=' 'DUMMY_SEARCH_INCLUDE='
    substituteInPlace configure --replace \
      'SEARCH_LIB=' 'DUMMY_SEARCH_LIB='
    substituteInPlace configure --replace \
      /usr /no-such-path
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace \
      'ac_cv_prog_SETFILE="/Developer/Tools/SetFile"' \
      'ac_cv_prog_SETFILE="${setfile}/bin/SetFile"'
    substituteInPlace configure --replace \
      "-framework System" "-lSystem"
  '';

  postInstall = "
    pushd $out/include
    ln -s wx-*/* .
    popd
  ";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.wxwidgets.org/";
    description = "A Cross-Platform C++ GUI Library";
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

  passthru = {
    inherit gtk;
    inherit compat28 compat30 unicode;
  };
}
