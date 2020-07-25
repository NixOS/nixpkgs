{ stdenv, fetchurl, pkgconfig, gtk2, libXinerama, libSM, libXxf86vm, xorgproto
, gstreamer, gst-plugins-base, GConf, setfile
, libGLSupported ? stdenv.lib.elem stdenv.hostPlatform.system stdenv.lib.platforms.mesaPlatforms
, withMesa ? stdenv.lib.elem stdenv.hostPlatform.system stdenv.lib.platforms.mesaPlatforms
, libGLU ? null, libGL ? null
, compat24 ? false, compat26 ? true, unicode ? true
, Carbon ? null, Cocoa ? null, Kernel ? null, QuickTime ? null, AGL ? null
}:

assert withMesa -> libGLU != null && libGL != null;

with stdenv.lib;

let
  version = "2.9.4";
in
stdenv.mkDerivation {
  pname = "wxwidgets";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/wxwindows/wxWidgets-${version}.tar.bz2";
    sha256 = "04jda4bns7cmp7xy68qz112yg0lribpc6xs5k9gilfqcyhshqlvc";
  };

  patches = [
    (fetchurl { # https://trac.wxwidgets.org/ticket/17942
      url = "https://trac.wxwidgets.org/raw-attachment/ticket/17942/"
          + "fix_assertion_using_hide_in_destroy.diff";
      sha256 = "009y3dav79wiig789vkkc07g1qdqprg1544lih79199kb1h64lvy";
    })
  ];

  buildInputs =
    [ gtk2 libXinerama libSM libXxf86vm xorgproto gstreamer
      gst-plugins-base GConf ]
    ++ optional withMesa libGLU
    ++ optionals stdenv.isDarwin [ setfile Carbon Cocoa Kernel QuickTime ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = optional stdenv.isDarwin AGL;

  configureFlags =
    [ "--enable-gtk2" "--disable-precomp-headers" "--enable-mediactrl"
      (if compat24 then "--enable-compat24" else "--disable-compat24")
      (if compat26 then "--enable-compat26" else "--disable-compat26") ]
    ++ optional unicode "--enable-unicode"
    ++ optional withMesa "--with-opengl"
    ++ optionals stdenv.isDarwin
      # allow building on 64-bit
      [ "--with-cocoa" "--enable-universal-binaries" "--with-macosx-version-min=10.7" ];

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
    gtk = gtk2;
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
