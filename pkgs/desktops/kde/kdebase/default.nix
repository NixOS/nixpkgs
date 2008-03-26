{ stdenv, fetchurl, pkgconfig, x11, xlibs, zlib, libpng, libjpeg, perl
, qt, kdelibs, openssl, bzip2, fontconfig
}:

let version = "3.5.7"; in

stdenv.mkDerivation {
  name = "kdebase-3.5.7";
  
  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/kdebase-${version}.tar.bz2";
    md5 = "b421e01b3ee712549ee967f58ed24de0";
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

  # Prevent configure from looking for pkg-config and freetype-config
  # in the wrong location (it looks in /usr/bin etc. *before* looking
  # in $PATH).
  preConfigure = ''
    substituteInPlace configure \
      --replace /usr/bin /no-such-path \
      --replace /usr/local/bin /no-such-path \
      --replace /opt/local/bin /no-such-path
  '';

  # Quick hack to work around a faulty dependency in
  # konqueror/keditbookmarks/Makefile.am (${includedir} should be
  # ${kdelibs} or so).
  preBuild = ''
    ensureDir $out/include
    ln -s ${kdelibs}/include/kbookmarknotifier.h $out/include/
  '';
  
  postInstall = "rm $out/include/kbookmarknotifier.h";
}
