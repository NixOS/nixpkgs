args: with args;
let common =
rec {
  setupHook = ./setup-hook.sh;  
  propagatedBuildInputs = [libXft libXrender libXrandr randrproto xextproto
  libXinerama xineramaproto libXcursor zlib libjpeg mysql libpng which mesa
  libXmu openssl dbus cups pkgconfig libXext freetype fontconfig inputproto
  fixesproto libXfixes glib libtiff];
  prefixKey = "-prefix ";
  configureFlags = "
    -v -no-separate-debug-info -release -nomake examples -nomake demos
    -system-zlib -system-libpng -system-libjpeg -fast
    -qt-gif -confirm-license
    -opengl -xrender -xrandr -xinerama -xcursor -qt-sql-mysql
    -qdbus -cups -glib -xfixes
    -fontconfig -I${freetype}/include/freetype2";
  patchPhase = "sed -e 's@/bin/pwd@pwd@' -i configure; sed -e 's@/usr@/FOO@' -i config.tests/*/*.test -i mkspecs/*/*.conf";
}; in
rec {
	trolltech = stdenv.mkDerivation (common // {
	  name = "qt-4.3.1";
	  src = fetchurl {
		url = ftp://ftp.trolltech.com/qt/source/qt-x11-opensource-src-4.3.1.tar.gz;
		sha256 = "0qg6apy2r7jbbfinxh0v1jm08yv890r40hhmy5cysn239v3x0nad";
	  };
	  patchPhase = common.patchPhase;
	});
	kde = stdenv.mkDerivation (common // {
	  name = "qt-kde-4.3svn";
	  src = fetchsvn {
		  url = svn://anonsvn.kde.org/home/kde/trunk/qt-copy;
		  rev = "732646";
		  md5 = "9757de3dce16b483f2f358d287c848ee";
	  };
	  patchPhase = "mkdir .svn; bash apply_patches;" + common.patchPhase;
	});
	default = kde;
}
