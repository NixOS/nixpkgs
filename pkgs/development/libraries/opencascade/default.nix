{stdenv, fetchurl, mesa, tcl, tk, file, libXmu, cmake, qt4, freetype}:

stdenv.mkDerivation rec {
  name = "opencascade-6.6.0";
  src = fetchurl {
    url = http://files.opencascade.com/OCCT/OCC_6.6.0_release/OpenCASCADE660.tgz;
    sha256 = "0q2xn915w9skv9sj74lxnyv9g3b0yi1j04majyzxk6sv4nra97z3";
  };

  buildInputs = [ cmake mesa tcl tk file libXmu qt4 freetype ];

  preUnpack = ''
    sourceRoot=`pwd`/ros/adm/cmake
    cmakeFlags="$cmakeFlags -DINSTALL_DIR=$out -D3RDPARTY_TCL_DIR=${tcl} -D3RDPARTY_FREETYPE_DIR=${freetype.dev}"
  '';

  # https://bugs.freedesktop.org/show_bug.cgi?id=83631
  NIX_CFLAGS_COMPILE = "-DGLX_GLXEXT_LEGACY";

  postInstall = ''
    mv $out/inc $out/include
    mkdir -p $out/share/doc/${name}
    cp -R ../../../doc $out/share/doc/${name}
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Open CASCADE Technology, libraries for 3D modeling and numerical simulation";
    homepage = http://www.opencascade.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
