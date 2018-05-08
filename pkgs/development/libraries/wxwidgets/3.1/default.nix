{ stdenv, fetchurl, fetchpatch, pkgconfig
, gtk2, gtk3, libXinerama, libSM, libXxf86vm
, xf86vidmodeproto , gstreamer, gst-plugins-base, GConf, setfile
, withMesa ? true, libGLU ? null, libGL ? null
, compat28 ? true, compat30 ? true, unicode ? true
, withGtk2 ? false
, withWebKit ? true, webkitgtk24x-gtk2 ? null, webkitgtk ? null
, AGL ? null, Carbon ? null, Cocoa ? null, Kernel ? null, QTKit ? null
}:


assert withMesa -> libGLU != null && libGL != null;
assert withWebKit -> (if withGtk2 then webkitgtk24x-gtk2 else webkitgtk) != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "wxWidgets-${version}";
  version = "3.1.1";

  src = fetchurl {
    url = "https://github.com/wxWidgets/wxWidgets/releases/download/v${version}/${name}.tar.bz2";
    sha256 = "17hm4q3y3x9rv3zhwxcj9vhs75inq7ydrgx9gvmhk2wggvhxy9f9";
  };

  buildInputs =
    [ (if withGtk2 then gtk2 else gtk3) libXinerama libSM libXxf86vm xf86vidmodeproto gstreamer
      gst-plugins-base GConf ]
    ++ optional withMesa libGLU
    ++ optional withWebKit (if withGtk2 then webkitgtk24x-gtk2 else webkitgtk)
    ++ optionals stdenv.isDarwin [ setfile Carbon Cocoa Kernel QTKit ];

  nativeBuildInputs = [ pkgconfig ];

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
      (enableFeature compat28 "compat28")
      (enableFeature compat30 "compat30") ]
    ++ optional unicode "--enable-unicode"
    ++ optional withMesa "--with-opengl"
    ++ optionals stdenv.isDarwin
      # allow building on 64-bit
      [ "--with-cocoa" "--enable-universal-binaries" "--with-macosx-version-min=10.7" ]
    ++ optionals withWebKit
      [ "--enable-webview" "--enable-webviewwebkit" ];

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
    inherit compat28 compat30 unicode withGtk2 withWebKit;
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
