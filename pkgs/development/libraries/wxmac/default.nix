{ stdenv, fetchurl
, expat, libiconv, libjpeg, libpng, libtiff, zlib
, setfile, rez, derez
, AGL, Cocoa, Kernel, QuickTime
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "3.0.2";
  name = "wxmac-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/wxwindows/wxWidgets-${version}.tar.bz2";
    sha256 = "346879dc554f3ab8d6da2704f651ecb504a22e9d31c17ef5449b129ed711585d";
  };

  patches = [ ./wx.patch ];

  buildInputs = [
    expat libiconv libjpeg libpng libtiff zlib
    Cocoa Kernel QuickTime setfile rez derez
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

  meta = {
    platforms = platforms.darwin;
    maintainers = [ maintainers.lnl7 ];
  };
}
