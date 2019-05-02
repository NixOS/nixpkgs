{ stdenv, fetchzip, fetchpatch, expat, libiconv, libjpeg, libpng, libtiff, zlib
# darwin only attributes
, cf-private, derez, rez, setfile
, AGL, Cocoa, Kernel
}:

stdenv.mkDerivation rec {
  version = "3.0.4";
  name = "wxmac-${version}";

  src = fetchzip {
    url = "https://github.com/wxWidgets/wxWidgets/archive/v${version}.tar.gz";
    sha256 = "19mqglghjjqjgz4rbybn3qdgn2cz9xc511nq1pvvli9wx2k8syl1";
  };

  buildInputs = [
    expat libiconv libjpeg libpng libtiff zlib
    derez rez setfile
    Cocoa Kernel

    # Needed for CFURLGetFSRef, etc. which have deen deprecated
    # since 10.9 and are not part of swift-corelibs CoreFoundation.
    cf-private
  ];

  propagatedBuildInputs = [ AGL ];

  postPatch = ''
    substituteInPlace configure --replace "-framework System" -lSystem
  '';

  configureFlags = [
    "wx_cv_std_libfullpath=/var/empty"
    "--with-macosx-version-min=10.7"
    "--enable-unicode"
    "--with-osx_cocoa"
    "--enable-std_string"
    "--enable-display"
    "--with-opengl"
    "--with-libjpeg"
    "--with-libtiff"
    "--without-liblzma"
    "--with-libpng"
    "--with-zlib"
    "--enable-dnd"
    "--enable-clipboard"
    "--enable-webkit"
    "--enable-svg"
    "--enable-graphics_ctx"
    "--enable-controls"
    "--enable-dataviewctrl"
    "--with-expat"
    "--disable-precomp-headers"
    "--disable-mediactrl"
  ];

  checkPhase = ''
    ./wx-config --libs
  '';

  NIX_CFLAGS_COMPILE = "-Wno-undef";

  doCheck = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.darwin;
    license = licenses.wxWindows;
    maintainers = [ maintainers.lnl7 ];
    homepage = https://www.wxwidgets.org/;
    description = "a C++ library that lets developers create applications for Windows, macOS, Linux and other platforms with a single code base";
    longDescription = "wxWidgets gives you a single, easy-to-use API for writing GUI applications on multiple platforms that still utilize the native platform's controls and utilities. Link with the appropriate library for your platform and compiler, and your application will adopt the look and feel appropriate to that platform. On top of great GUI functionality, wxWidgets gives you: online help, network programming, streams, clipboard and drag and drop, multithreading, image loading and saving in a variety of popular formats, database support, HTML viewing and printing, and much more.";
    broken = true;
  };
}
