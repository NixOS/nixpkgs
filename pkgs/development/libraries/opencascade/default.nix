{stdenv, fetchurl, mesa, tcl, tk, file, libXmu, automake, autoconf, libtool, qt4,
ftgl, freetype}:

stdenv.mkDerivation rec {
  name = "opencascade-6.5.2";
  src = fetchurl {
    url = http://files.opencascade.com/OCCT/OCC_6.5.2_release/OpenCASCADE652.tar.gz;
    sha256 = "0nsfjhd6rv1fmq8jbyzcs0f13h4xfld487vqs9bwd4lbwcfqxwcy";
  };

  buildInputs = [ mesa tcl tk file libXmu automake autoconf libtool qt4 ftgl freetype ];

  preUnpack = ''
    sourceRoot=`pwd`/ros
  '';

  preConfigure = ''
    sh ./build_configure
  '';

  NIX_CFLAGS_COMPILE = "-I${ftgl}/include/FTGL -I${freetype}/include/freetype2";

  configureFlags = [ "--with-tcl=${tcl}/lib" "--with-tk=${tk}/lib" ];

  postInstall = ''
    mv $out/inc $out/include
    mkdir -p $out/share/doc/${name}
    cp -R ../doc $out/share/doc/${name}
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Open CASCADE Technology, libraries for 3D modeling and numerical simulation";
    homepage = http://www.opencascade.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
