{ stdenv, fetchurl, fetchpatch, expat, libiconv, libjpeg, libpng, libtiff, zlib
# darwin only attributes
, derez, rez, setfile
, AGL, Cocoa, Kernel
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "3.0.2";
  name = "wxmac-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/wxwindows/wxWidgets-${version}.tar.bz2";
    sha256 = "346879dc554f3ab8d6da2704f651ecb504a22e9d31c17ef5449b129ed711585d";
  };

  patches =
    [ # Use std::abs() from <cmath> instead of abs() from <math.h> to avoid problems
      # with abiguous overloads for clang-3.8 and gcc6.
      (fetchpatch {
        name = "patch-stc-abs.diff";
        url = https://github.com/wxWidgets/wxWidgets/commit/73e9e18ea09ffffcaac50237def0d9728a213c02.patch;
        sha256 = "0w5whmfzm8waw62jmippming0zffa9064m5b3aw5nixph21rlcvq";
      })

      # Various fixes related to Yosemite. Revisit in next stable release.
      # Please keep an eye on http://trac.wxwidgets.org/ticket/16329 as well
      # Theoretically the above linked patch should still be needed, but it isn't.
      # Try to find out why.
      (fetchpatch {
        name = "patch-yosemite.diff";
        url = https://raw.githubusercontent.com/Homebrew/formula-patches/bbf4995/wxmac/patch-yosemite.diff;
        sha256 = "0ss66z2a79v976mvlrskyj1zmkyaz8hbwm98p29bscfvcx5845jb";
      })

      # Remove uncenessary <QuickTime/QuickTime.h> includes
      # http://trac.wxwidgets.org/changeset/f6a2d1caef5c6d412c84aa900cb0d3990b350938/git-wxWidgets
      (fetchpatch {
        name = "patch-quicktime-removal.diff";
        url = https://raw.githubusercontent.com/Homebrew/formula-patches/bbf4995/wxmac/patch-quicktime-removal.diff;
        sha256 = "0mzvdk8r70p9s1wj7qzdsqmdrlxlf2dalh9gqs8xjkqq2666yp0y";
      })

      # Patch for wxOSXPrintData, custom paper not applied
      # http://trac.wxwidgets.org/ticket/16959
      (fetchpatch {
        name = "wxPaperCustomPatch.patch";
        url = http://trac.wxwidgets.org/raw-attachment/ticket/16959/wxPaperCustomPatch.patch;
        sha256 = "0xgscv86f8dhggn9n8bhlq9wlj3ydsicgy9v35sraxyma18cbjvl";
      })
    ];

  buildInputs = [
    expat libiconv libjpeg libpng libtiff zlib
    derez rez setfile
    Cocoa Kernel
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
    license = licenses.wxWindows;
    maintainers = [ maintainers.lnl7 ];
    homepage = https://www.wxwidgets.org/;
    description = "a C++ library that lets developers create applications for Windows, Mac OS X, Linux and other platforms with a single code base";
    longDescription = "wxWidgets gives you a single, easy-to-use API for writing GUI applications on multiple platforms that still utilize the native platform's controls and utilities. Link with the appropriate library for your platform and compiler, and your application will adopt the look and feel appropriate to that platform. On top of great GUI functionality, wxWidgets gives you: online help, network programming, streams, clipboard and drag and drop, multithreading, image loading and saving in a variety of popular formats, database support, HTML viewing and printing, and much more.";
  };
}
