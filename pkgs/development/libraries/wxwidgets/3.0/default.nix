{ lib
, stdenv
, fetchFromGitHub
, gst_all_1
, gtk2
, gtk3
, libGL
, libGLU
, libSM
, libXinerama
, libXxf86vm
, pkg-config
, xorgproto
, withMesa ? lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms
, compat24 ? false
, compat26 ? true
, unicode ? true
, withGtk2 ? true
, withWebKit ? false, webkitgtk
, AGL
, Carbon
, Cocoa
, Kernel
, QTKit
, setfile
}:

assert withGtk2 -> (!withWebKit);

let
  inherit (gst_all_1) gstreamer gst-plugins-base;
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

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gstreamer
    gst-plugins-base
    gtk
    libSM
    libXinerama
    libXxf86vm
    xorgproto
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

  patches = [
    # https://github.com/wxWidgets/wxWidgets/issues/17942
    ../patches/0001-fix-assertion-using-hide-in-destroy.patch
  ];

  configureFlags = [
    "--disable-precomp-headers"
    "--enable-mediactrl"
    (if compat24 then "--enable-compat24" else "--disable-compat24")
    (if compat26 then "--enable-compat26" else "--disable-compat26")
  ]
  ++ lib.optional unicode "--enable-unicode"
  ++ lib.optional withMesa "--with-opengl"
  ++ lib.optionals stdenv.isDarwin [ # allow building on 64-bit
    "--enable-universal-binaries"
    "--with-cocoa"
    "--with-macosx-version-min=10.7"
  ]
  ++ lib.optionals withWebKit [
    "--enable-webview"
    "--enable-webview-webkit"
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
    maintainers = with maintainers; [ ];
    platforms = platforms.linux ++ platforms.darwin;
    badPlatforms = [ "x86_64-darwin" ];
  };

  passthru = {
    inherit gtk;
    inherit compat24 compat26 unicode;
  };
}
