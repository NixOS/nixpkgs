{ lib
, stdenv
, fetchFromGitHub
, expat
, libiconv
, libjpeg
, libpng
, libtiff
, zlib
, AGL
, Cocoa
, Kernel
, WebKit
, derez
, rez
, setfile
}:

stdenv.mkDerivation rec {
  pname = "wxmac";
  version = "3.0.5.1";

  src = fetchFromGitHub {
    owner = "wxWidgets";
    repo = "wxWidgets";
    rev = "v${version}";
    hash = "sha256-I91douzXDAfDgm4Pplf17iepv4vIRhXZDRFl9keJJq0=";
  };

  buildInputs = [
    expat
    libiconv
    libjpeg
    libpng
    libtiff
    zlib
    AGL
    Cocoa
    Kernel
    WebKit
    derez
    rez
    setfile
  ];

  postPatch = ''
    substituteInPlace configure --replace "-framework System" "-lSystem"
  '';

  configureFlags = [
    "--disable-mediactrl"
    "--disable-precomp-headers"
    "--enable-clipboard"
    "--enable-controls"
    "--enable-dataviewctrl"
    "--enable-display"
    "--enable-dnd"
    "--enable-graphics_ctx"
    "--enable-std_string"
    "--enable-svg"
    "--enable-unicode"
    "--enable-webkit"
    "--with-expat"
    "--with-libjpeg"
    "--with-libpng"
    "--with-libtiff"
    "--with-macosx-version-min=10.7"
    "--with-opengl"
    "--with-osx_cocoa"
    "--with-zlib"
    "--without-liblzma"
    "wx_cv_std_libfullpath=/var/empty"
  ];

  doCheck = true;
  checkPhase = ''
    ./wx-config --libs
  '';

  NIX_CFLAGS_COMPILE = "-Wno-undef";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.wxwidgets.org/";
    description = "A Cross-Platform C++ GUI Library - MacOS-only build";
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
    maintainers = with maintainers; [ lnl7 ];
    platforms = platforms.darwin;
  };
}
