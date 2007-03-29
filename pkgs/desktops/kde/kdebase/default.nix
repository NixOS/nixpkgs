{ stdenv, fetchurl, pkgconfig, x11, xlibs, zlib, libpng, libjpeg, perl
, qt, kdelibs, openssl, bzip2, fontconfig
}:

stdenv.mkDerivation {
  name = "kdebase-3.5.6";
  
  src = fetchurl {
    url = http://ftp.scarlet.be/pub/kde/stable/3.5.6/src/kdebase-3.5.6.tar.bz2;
    sha256 = "0zmxnw4p8bkd2b867cwdzdnp36ikwnz0ffrbx6d3ylz1nbw3anr4";
  };

  buildInputs = [
    pkgconfig x11 zlib libpng libjpeg perl
    qt kdelibs openssl bzip2 fontconfig
    xlibs.libXrandr xlibs.libXinerama xlibs.libXau xlibs.libXdmcp
    xlibs.libXcursor xlibs.libfontenc xlibs.imake xlibs.bdftopcf
    xlibs.libxkbfile xlibs.xf86miscproto xlibs.libXxf86misc
    xlibs.scrnsaverproto xlibs.libXScrnSaver
  ];

  configureFlags = "
    --without-arts 
    --with-ssl-dir=${openssl}
    --with-extra-includes=${libjpeg}/include
  ";

  # Quick hack to work around a faulty dependency in
  # konqueror/keditbookmarks/Makefile.am (${includedir} should be
  # ${kdelibs} or so).
  preBuild = "ensureDir $out/include; ln -s ${kdelibs}/include/kbookmarknotifier.h $out/include/";
  postInstall = "rm $out/include/kbookmarknotifier.h";
}
