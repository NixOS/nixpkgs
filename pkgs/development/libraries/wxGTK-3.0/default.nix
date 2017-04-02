{ stdenv, fetchurl, fetchpatch, pkgconfig, gtk2, libXinerama, libSM, libXxf86vm
, xf86vidmodeproto , gstreamer, gst-plugins-base, GConf, setfile
, withMesa ? true, mesa ? null, compat24 ? false, compat26 ? true, unicode ? true
, withWebKit ? false, webkitgtk2 ? null
, AGL ? null, Carbon ? null, Cocoa ? null, Kernel ? null, QTKit ? null
}:


assert withMesa -> mesa != null;
assert withWebKit -> webkitgtk2 != null;

with stdenv.lib;

let
  version = "3.0.2";
in
stdenv.mkDerivation {
  name = "wxwidgets-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/wxwindows/wxWidgets-${version}.tar.bz2";
    sha256 = "0paq27brw4lv8kspxh9iklpa415mxi8zc117vbbbhfjgapf7js1l";
  };

  buildInputs =
    [ gtk2 libXinerama libSM libXxf86vm xf86vidmodeproto gstreamer
      gst-plugins-base GConf ]
    ++ optional withMesa mesa
    ++ optional withWebKit webkitgtk2
    ++ optionals stdenv.isDarwin [ setfile Carbon Cocoa Kernel QTKit ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = optional stdenv.isDarwin AGL;

  patches = [ (fetchpatch {
    url = "https://raw.githubusercontent.com/jessehager/MINGW-packages/af6ece963d8157dd3fbc710bcc190647c4924c63/mingw-w64-wxwidgets/wxWidgets-3.0.2-gcc6-abs.patch";
    sha256 = "0100pg0z7i6cjyysf2k3330pmqmdaxgc9hz6kxnfvc31dynjcq3h";
  }) ];

  configureFlags =
    [ "--enable-gtk2" "--disable-precomp-headers" "--enable-mediactrl"
      (if compat24 then "--enable-compat24" else "--disable-compat24")
      (if compat26 then "--enable-compat26" else "--disable-compat26") ]
    ++ optional unicode "--enable-unicode"
    ++ optional withMesa "--with-opengl"
    ++ optionals stdenv.isDarwin
      # allow building on 64-bit
      [ "--with-cocoa" "--enable-universal-binaries" "--with-macosx-version-min=10.7" ]
    ++ optionals withWebKit
      ["--enable-webview" "--enable-webview-webkit"];

  SEARCH_LIB = optionalString withMesa "${mesa}/lib";

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
    platforms = with stdenv.lib.platforms; darwin ++ linux;
  };
}
