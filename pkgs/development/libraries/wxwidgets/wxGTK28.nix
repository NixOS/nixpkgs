{ lib
, stdenv
, fetchurl
, cairo
, gtk2
, libGL
, libGLU
, libSM
, libX11
, libXinerama
, libXxf86vm
, pkg-config
, xorgproto
, compat24 ? false
, compat26 ? true
, unicode ? true
, withMesa ? lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms
}:

assert withMesa -> libGLU != null && libGL != null;

stdenv.mkDerivation rec {
  pname = "wxGTK";
  version = "2.8.12.1";

  src = fetchurl {
    url = "mirror://sourceforge/wxpython/wxPython-src-${version}.tar.bz2";
    hash = "sha256-Hz8VPZ8VBMbOLSxLI+lAuPWLgfTLo1zaGluzEUIkPNA=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    cairo
    gtk2
    libSM
    libX11
    libXinerama
    libXxf86vm
    xorgproto
  ]
  ++ lib.optional withMesa libGLU;

  configureFlags = [
    "--enable-gtk2"
    "--disable-precomp-headers"
    "--enable-mediactrl"
    "--enable-graphics_ctx"
    (if compat24 then "--enable-compat24" else "--disable-compat24")
    (if compat26 then "--enable-compat26" else "--disable-compat26")
  ]
  ++ lib.optional unicode "--enable-unicode"
  ++ lib.optional withMesa "--with-opengl";

  hardeningDisable = [ "format" ];

  # These variables are used by configure to find some dependencies.
  SEARCH_INCLUDE =
    "${libXinerama.dev}/include ${libSM.dev}/include ${libXxf86vm.dev}/include";
  SEARCH_LIB =
    "${libXinerama.out}/lib ${libSM.out}/lib ${libXxf86vm.out}/lib "
    + lib.optionalString withMesa "${libGLU.out}/lib ${libGL.out}/lib ";

  # Work around a bug in configure.
  NIX_CFLAGS_COMPILE = "-DHAVE_X11_XLIB_H=1 -lX11 -lcairo -Wno-narrowing";

  preConfigure = ''
    substituteInPlace configure --replace \
      'SEARCH_INCLUDE=' 'DUMMY_SEARCH_INCLUDE='
    substituteInPlace configure --replace \
      'SEARCH_LIB=' 'DUMMY_SEARCH_LIB='
    substituteInPlace configure --replace \
      /usr /no-such-path
  '';

  postBuild = ''
    pushd contrib/src
    make
    popd
  '';

  postInstall = ''
    pushd contrib/src
    make install
    popd
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
    platforms = platforms.linux;
  };

  passthru = {
    inherit compat24 compat26 unicode;
    gtk = gtk2;
  };
}
