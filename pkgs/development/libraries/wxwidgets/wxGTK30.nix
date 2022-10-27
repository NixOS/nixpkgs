{ lib
, stdenv
, expat
, fetchFromGitHub
, gst_all_1
, withGtk2 ? true
, gtk2
, gtk3
, libGL
, libGLU
, libSM
, libXinerama
, libXxf86vm
, libpng
, libtiff
, libjpeg_turbo
, zlib
, pkg-config
, xorgproto
, compat26 ? false
, compat28 ? true
, unicode ? true
, withMesa ? lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms
, withWebKit ? false
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
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "wxWidgets";
    repo = "wxWidgets";
    rev = "v${version}";
    hash = "sha256-p69nNCg552j+nldGY0oL65uFRVu4xXCkoE10F5MwY9A=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    libpng
    libtiff
    libjpeg_turbo
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    gtk
    libSM
    libXinerama
    libXxf86vm
    xorgproto
  ]
  ++ lib.optional withMesa libGLU
  ++ lib.optional (withWebKit && stdenv.isLinux) webkitgtk
  ++ lib.optional (withWebKit && stdenv.isDarwin) WebKit
  ++ lib.optionals stdenv.isDarwin [
    expat
    setfile
    Carbon
    Cocoa
    Kernel
    QTKit
    AVFoundation
    AVKit
  ];

  propagatedBuildInputs = lib.optional stdenv.isDarwin AGL;

  patches = [
    # https://github.com/wxWidgets/wxWidgets/issues/17942
    ./patches/0001-fix-assertion-using-hide-in-destroy.patch
  ];

  configureFlags = [
    "--disable-precomp-headers"
    "--enable-mediactrl"
    (if compat26 then "--enable-compat26" else "--disable-compat26")
    (if compat28 then "--enable-compat28" else "--disable-compat28")
  ] ++ lib.optional unicode "--enable-unicode"
  ++ lib.optional withMesa "--with-opengl"
  ++ lib.optionals stdenv.isDarwin [
    # allow building on 64-bit
    "--enable-universal-binaries"
    "--with-macosx-version-min=10.7"
    "--with-osx_cocoa"
    "--with-libiconv"
  ] ++ lib.optionals withWebKit [
    "--enable-webview"
    "--enable-webviewwebkit"
  ];

  SEARCH_LIB = "${libGLU.out}/lib ${libGL.out}/lib";

  preConfigure = ''
    substituteInPlace configure --replace \
      'SEARCH_INCLUDE=' 'DUMMY_SEARCH_INCLUDE='
    substituteInPlace configure --replace \
      'SEARCH_LIB=' 'DUMMY_SEARCH_LIB='
    substituteInPlace configure --replace \
      /usr /no-such-path
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure \
      --replace 'ac_cv_prog_SETFILE="/Developer/Tools/SetFile"' 'ac_cv_prog_SETFILE="${setfile}/bin/SetFile"'
    substituteInPlace configure \
      --replace "-framework System" "-lSystem"
  '';

  postInstall = ''
    pushd $out/include
    ln -s wx-*/* .
    popd
  '';

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
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };

  passthru = {
    inherit gtk;
    inherit compat26 compat28 unicode;
  };
}
