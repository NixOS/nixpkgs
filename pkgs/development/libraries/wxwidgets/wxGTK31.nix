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
, withGtk2 ? true
, withMesa ? lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms
, withWebKit ? false, webkitgtk
, darwin
}:

assert withMesa -> libGLU != null && libGL != null;
assert withWebKit -> webkitgtk != null;

assert withGtk2 -> (!withWebKit);

let
  inherit (darwin.stubs) setfile;
  inherit (darwin.apple_sdk.frameworks) AGL Carbon Cocoa Kernel QTKit;
  inherit (gnome2) GConf;
  inherit (gst_all_1) gst-plugins-base gstreamer;
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
    gst-plugins-base
    gstreamer
    gtk
    libSM
    libXinerama
    libXtst
    libXxf86vm
    xorgproto
  ]
  ++ lib.optionals withGtk2 [
    GConf
  ]
  ++ lib.optional withMesa libGLU
  ++ lib.optional withWebKit webkitgtk
  ++ lib.optionals stdenv.isDarwin [
    Carbon
    Cocoa
    Kernel
    QTKit
    setfile
  ];

  propagatedBuildInputs = lib.optional stdenv.isDarwin AGL;

  configureFlags = [
    "--disable-precomp-headers"
    "--enable-mediactrl"
    (if compat28 then "--enable-compat28" else "--disable-compat28")
    (if compat30 then "--enable-compat30" else "--disable-compat30")
  ]
  ++ lib.optional unicode "--enable-unicode"
  ++ lib.optional withMesa "--with-opengl"
  ++ lib.optionals stdenv.isDarwin [
    # allow building on 64-bit
    "--enable-universal-binaries"
    "--with-cocoa"
    "--with-macosx-version-min=10.7"
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
    maintainers = with maintainers; [ AndersonTorres tfmoraes ];
    platforms = platforms.unix;
    badPlatforms = platforms.darwin; # ofBorg is failing, don't know if internal
  };

  passthru = {
    inherit gtk;
    inherit compat28 compat30 unicode;
  };
}
