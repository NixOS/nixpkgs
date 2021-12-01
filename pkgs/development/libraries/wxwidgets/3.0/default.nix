{ lib, stdenv, fetchFromGitHub, fetchurl, pkg-config
, libXinerama, libSM, libXxf86vm
, gtk2, gtk3
, xorgproto, gst_all_1, setfile
, libGLSupported ? lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms
, withMesa ? libGLSupported
, libGLU, libGL
, compat24 ? false, compat26 ? true, unicode ? true
, withGtk2 ? true
, withWebKit ? false, webkitgtk
, AGL, Carbon, Cocoa, Kernel, QTKit
}:

with lib;

assert assertMsg (withGtk2 -> withWebKit == false) "wxGTK30: You cannot enable withWebKit when using withGtk2.";

stdenv.mkDerivation rec {
  pname = "wxwidgets";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "wxWidgets";
    repo = "wxWidgets";
    rev = "v${version}";
    sha256 = "1l33629ifx2dl2j71idqbd2qb6zb1d566ijpkvz6irrr50s6gbx7";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libXinerama libSM libXxf86vm xorgproto gst_all_1.gstreamer gst_all_1.gst-plugins-base
  ] ++ optional withGtk2 gtk2
    ++ optional (!withGtk2) gtk3
    ++ optional withMesa libGLU
    ++ optional withWebKit webkitgtk
    ++ optionals stdenv.isDarwin [ setfile Carbon Cocoa Kernel QTKit ];

  propagatedBuildInputs = optional stdenv.isDarwin AGL;

  patches = [
    (fetchurl { # https://trac.wxwidgets.org/ticket/17942
      url = "https://trac.wxwidgets.org/raw-attachment/ticket/17942/"
          + "fix_assertion_using_hide_in_destroy.diff";
      sha256 = "009y3dav79wiig789vkkc07g1qdqprg1544lih79199kb1h64lvy";
    })
  ];

  configureFlags =
    [ "--disable-precomp-headers" "--enable-mediactrl"
      (if compat24 then "--enable-compat24" else "--disable-compat24")
      (if compat26 then "--enable-compat26" else "--disable-compat26") ]
    ++ optional unicode "--enable-unicode"
    ++ optional withMesa "--with-opengl"
    ++ optionals stdenv.isDarwin
      # allow building on 64-bit
      [ "--with-cocoa" "--enable-universal-binaries" "--with-macosx-version-min=10.7" ]
    ++ optionals withWebKit
      ["--enable-webview" "--enable-webview-webkit"];

  SEARCH_LIB = "${libGLU.out}/lib ${libGL.out}/lib ";

  preConfigure = "
    substituteInPlace configure --replace 'SEARCH_INCLUDE=' 'DUMMY_SEARCH_INCLUDE='
    substituteInPlace configure --replace 'SEARCH_LIB=' 'DUMMY_SEARCH_LIB='
    substituteInPlace configure --replace /usr /no-such-path
  " + optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace \
      'ac_cv_prog_SETFILE="/Developer/Tools/SetFile"' \
      'ac_cv_prog_SETFILE="${setfile}/bin/SetFile"'
    substituteInPlace configure --replace \
      "-framework System" \
      -lSystem
  '';

  postInstall = "
    (cd $out/include && ln -s wx-*/* .)
  ";

  passthru = {
    inherit compat24 compat26 unicode;
    gtk = if withGtk2 then gtk2 else gtk3;
  };

  enableParallelBuilding = true;

  meta = {
    platforms = with platforms; darwin ++ linux;
    license = licenses.wxWindows;
    homepage = "https://www.wxwidgets.org/";
    description = "a C++ library that lets developers create applications for Windows, macOS, Linux and other platforms with a single code base";
    longDescription = "wxWidgets gives you a single, easy-to-use API for writing GUI applications on multiple platforms that still utilize the native platform's controls and utilities. Link with the appropriate library for your platform and compiler, and your application will adopt the look and feel appropriate to that platform. On top of great GUI functionality, wxWidgets gives you: online help, network programming, streams, clipboard and drag and drop, multithreading, image loading and saving in a variety of popular formats, database support, HTML viewing and printing, and much more.";
    badPlatforms = [ "x86_64-darwin" ];
  };
}
