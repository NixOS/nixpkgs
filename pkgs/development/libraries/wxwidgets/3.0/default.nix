{ stdenv, fetchFromGitHub, fetchurl, fetchpatch, pkgconfig
, gtk2, gtk3, libXinerama, libSM, libXxf86vm
, xf86vidmodeproto , gstreamer, gst-plugins-base, GConf, setfile
, withMesa ? true, libGLU ? null, libGL ? null
, compat24 ? false, compat26 ? true, unicode ? true
, withGtk2 ? true
, withWebKit ? false, webkitgtk24x-gtk2 ? null, webkitgtk218x ? null
, AGL ? null, Carbon ? null, Cocoa ? null, Kernel ? null, QTKit ? null
}:


assert withMesa -> libGLU != null && libGL != null;
assert withWebKit -> (if withGtk2 then webkitgtk24x-gtk2 else webkitgtk218x) != null;

with stdenv.lib;

let
  version = "3.0.3.1";
in
stdenv.mkDerivation {
  name = "wxwidgets-${version}";

  src = fetchFromGitHub {
    owner = "wxWidgets";
    repo = "wxWidgets";
    rev = "v${version}";
    sha256 = "1b90in65k1ij6kyk41knxs86i6hx5lkz30gpvzdvh0cbjagv5asq";
  };

  buildInputs =
    [ (if withGtk2 then gtk2 else gtk3) libXinerama libSM libXxf86vm xf86vidmodeproto gstreamer
      gst-plugins-base GConf ]
    ++ optional withMesa libGLU
    ++ optional withWebKit (if withGtk2 then webkitgtk24x-gtk2 else webkitgtk218x)
    ++ optionals stdenv.isDarwin [ setfile Carbon Cocoa Kernel QTKit ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = optional stdenv.isDarwin AGL;

  patches = [
    (fetchurl { # https://trac.wxwidgets.org/ticket/17942
      url = "https://trac.wxwidgets.org/raw-attachment/ticket/17942/"
          + "fix_assertion_using_hide_in_destroy.diff";
      sha256 = "009y3dav79wiig789vkkc07g1qdqprg1544lih79199kb1h64lvy";
    })
    # "Add support for WebKit2GTK+ in wxWebView". Will be in 3.0.4
  ] ++ optional (!withGtk2) (fetchpatch {
      url = "https://github.com/wxWidgets/wxWidgets/commit/ec6e54bc893fb7516731ca9c71e0d0bbc5ae9ff7.patch";
      sha256 = "0gxd83xajm7gdv9rdzyvqwa2p5nz29nr23i0zx2dgfpsvz2qjp3q";
    });

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
    homepage = https://www.wxwidgets.org/;
    description = "a C++ library that lets developers create applications for Windows, macOS, Linux and other platforms with a single code base";
    longDescription = "wxWidgets gives you a single, easy-to-use API for writing GUI applications on multiple platforms that still utilize the native platform's controls and utilities. Link with the appropriate library for your platform and compiler, and your application will adopt the look and feel appropriate to that platform. On top of great GUI functionality, wxWidgets gives you: online help, network programming, streams, clipboard and drag and drop, multithreading, image loading and saving in a variety of popular formats, database support, HTML viewing and printing, and much more.";
  };
}
