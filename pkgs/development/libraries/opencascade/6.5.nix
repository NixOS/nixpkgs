{stdenv, fetchurl, mesa, tcl, tk, file, libXmu, automake, autoconf, libtool, qt4,
ftgl, freetype}:

stdenv.mkDerivation rec {
  name = "opencascade-6.5.4";
  src = fetchurl {
    url = http://files.opencascade.com/OCCT/OCC_6.5.4_release/OpenCASCADE654.tar.gz;
    sha256 = "1di08mc0wly4cdi3rh9kj52bk0bfpyk6dy03c9yfnv04i7z03kmy";
  };

  buildInputs = [ mesa tcl tk file libXmu automake autoconf libtool qt4 ftgl freetype ];

  preUnpack = ''
    sourceRoot=`pwd`/ros
  '';

  preConfigure = ''
    sh ./build_configure
  '';

  # -fpermissive helps building opencascade, although gcc detects a flaw in the code
  # and reports an error otherwise. Further versions may fix that.
  NIX_CFLAGS_COMPILE = "-fpermissive";

  configureFlags = [ "--with-tcl=${tcl}/lib" "--with-tk=${tk}/lib" "--with-qt=${qt4}" "--with-ftgl=${ftgl}" "--with-freetype=${freetype}" ];

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
