# kicad requires a special, patched version of wxwidgets on macOS. This is the
# purpose of this package. Hopefully, this will eventually go away and KiCad
# will use a stock wxwidgets on macOS, obviating the need for this packages.

{ stdenv, fetchgit, fetchurl, pkgconfig
, libXinerama, libSM, libXxf86vm, gtk3, xorgproto, gst_all_1
, libGLU, libGL
, compat24 ? false, compat26 ? true
, setfile, AGL, Carbon, Cocoa, Kernel, QTKit, WebKit, AVFoundation, AVKit
, ...
}:

with stdenv.lib;

assert libGLU != null && libGL != null;

stdenv.mkDerivation {
  version = "kicad-macos-3.0.4";
  pname = "wxwidgets";

  src = fetchgit {
    url = "https://gitlab.com/kicad/code/wxWidgets.git";
    rev = "53e3765367870187718fc7809f27efc9b40420f8";
    sha256 = "1yg02d47l4g57bhgn7n09s1k4rjal2mpj89vxiqg1k26zvs7cyc7";
  };

  buildInputs = [
    libXinerama libSM libXxf86vm xorgproto gst_all_1.gstreamer gst_all_1.gst-plugins-base
    gtk3 libGLU
    setfile Kernel QTKit WebKit AVFoundation AVKit AGL
  ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ Carbon Cocoa ];

  configureFlags =
    [ "--disable-precomp-headers" "--enable-mediactrl"
      (if compat24 then "--enable-compat24" else "--disable-compat24")
      (if compat26 then "--enable-compat26" else "--disable-compat26")
      "--with-cocoa" "--with-macosx-version-min=10.10"
      "--enable-webview" "--enable-webview-webkit"
      "--enable-unicode" "--with-opengl"
    ];

  SEARCH_LIB = "${libGLU.out}/lib ${libGL.out}/lib ";

  preConfigure = ''
    substituteInPlace configure --replace 'SEARCH_INCLUDE=' 'DUMMY_SEARCH_INCLUDE='
    substituteInPlace configure --replace 'SEARCH_LIB=' 'DUMMY_SEARCH_LIB='
    substituteInPlace configure --replace /usr /no-such-path
    substituteInPlace configure --replace \
      'ac_cv_prog_SETFILE="/Developer/Tools/SetFile"' \
      'ac_cv_prog_SETFILE="${setfile}/bin/SetFile"'
    substituteInPlace configure --replace "-framework System" -lSystem
  '';

  postInstall = "
    (cd $out/include && ln -s wx-*/* .)
  ";

  passthru = {
    inherit compat24 compat26;
    unicode = true;
    gtk = gtk3;
  };

  enableParallelBuilding = true;

  meta = rec {
    description = "Patched version of wxWidgets for KiCad on macOS";
    homepage = "https://gitlab.com/kicad/code/wxWidgets";
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.darwin;
  };
}
