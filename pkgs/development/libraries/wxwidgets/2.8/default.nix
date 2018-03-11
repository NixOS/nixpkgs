{ stdenv, fetchurl, pkgconfig, gtk2, libXinerama, libSM, libXxf86vm, xf86vidmodeproto
, gstreamer, gst-plugins-base, GConf, libX11, cairo
, withMesa ? true, libGLU ? null, libGL ? null
, compat24 ? false, compat26 ? true, unicode ? true,
}:

assert withMesa -> libGLU != null && libGL != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "2.8.12.1";
  name = "wxGTK-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/wxpython/wxPython-src-${version}.tar.bz2";
    sha256 = "1l1w4i113csv3bd5r8ybyj0qpxdq83lj6jrc5p7cc10mkwyiagqz";
  };

  buildInputs = [ gtk2 libXinerama libSM libXxf86vm xf86vidmodeproto gstreamer gst-plugins-base GConf libX11 cairo ]
    ++ optional withMesa libGLU;

  nativeBuildInputs = [ pkgconfig ];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--enable-gtk2"
    (if compat24 then "--enable-compat24" else "--disable-compat24")
    (if compat26 then "--enable-compat26" else "--disable-compat26")
    "--disable-precomp-headers"
    (if unicode then "--enable-unicode" else "")
    "--enable-mediactrl"
    "--enable-graphics_ctx"
  ] ++ optional withMesa "--with-opengl";

  # These variables are used by configure to find some dependencies.
  SEARCH_INCLUDE =
    "${libXinerama.dev}/include ${libSM.dev}/include ${libXxf86vm.dev}/include";
  SEARCH_LIB =
    "${libXinerama.out}/lib ${libSM.out}/lib ${libXxf86vm.out}/lib "
    + optionalString withMesa "${libGLU.out}/lib ${libGL.out}/lib ";

  # Work around a bug in configure.
  NIX_CFLAGS_COMPILE = [ "-DHAVE_X11_XLIB_H=1" "-lX11" "-lcairo" "-Wno-narrowing" ];

  preConfigure = "
    substituteInPlace configure --replace 'SEARCH_INCLUDE=' 'DUMMY_SEARCH_INCLUDE='
    substituteInPlace configure --replace 'SEARCH_LIB=' 'DUMMY_SEARCH_LIB='
    substituteInPlace configure --replace /usr /no-such-path
  ";

  postBuild = "(cd contrib/src && make)";

  postInstall = "
    (cd contrib/src && make install)
    (cd $out/include && ln -s wx-*/* .)
  ";

  passthru = {
    inherit compat24 compat26 unicode;
    gtk = gtk2;
  };

  enableParallelBuilding = true;

  meta = {
    platforms = platforms.linux;
    license = licenses.wxWindows;
    homepage = https://www.wxwidgets.org/;
    description = "a C++ library that lets developers create applications for Windows, macOS, Linux and other platforms with a single code base";
    longDescription = "wxWidgets gives you a single, easy-to-use API for writing GUI applications on multiple platforms that still utilize the native platform's controls and utilities. Link with the appropriate library for your platform and compiler, and your application will adopt the look and feel appropriate to that platform. On top of great GUI functionality, wxWidgets gives you: online help, network programming, streams, clipboard and drag and drop, multithreading, image loading and saving in a variety of popular formats, database support, HTML viewing and printing, and much more.";
  };
}
