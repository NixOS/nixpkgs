{stdenv, fetchurl, mesa, tcl, tk, file, libXmu, automake, autoconf, libtool, qt4,
ftgl, freetype}:

stdenv.mkDerivation rec {
  name = "opencascade-6.5.5";
  src = fetchurl {
    url = http://files.opencascade.com/OCCT/OCC_6.5.5_release/OpenCASCADE655.tgz;
    sha256 = "1dnik00adfh6dxvn9kgf35yjda8chbi05f71i9119idmmrcapipm";
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
  NIX_CFLAGS_COMPILE = "-fpermissive"
  # https://bugzilla.redhat.com/show_bug.cgi?id=902561
    + " -DUSE_INTERP_RESULT"
  # https://bugs.freedesktop.org/show_bug.cgi?id=83631
    + " -DGLX_GLXEXT_LEGACY";

  hardeningDisable = [ "format" ];

  configureFlags = [ "--with-tcl=${tcl}/lib" "--with-tk=${tk}/lib" "--with-qt=${qt4}" "--with-ftgl=${ftgl}" "--with-freetype=${freetype.dev}" ];

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
