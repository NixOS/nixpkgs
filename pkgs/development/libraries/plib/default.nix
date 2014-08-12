{ fetchurl, stdenv, mesa, freeglut, SDL
, libXi, libSM, libXmu, libXext, libX11,
enablePIC ? false }:

stdenv.mkDerivation rec {
  name = "plib-1.8.5";

  src = fetchurl {
    # XXX: The author doesn't use the orthodox SF way to store tarballs.
    url = "http://plib.sourceforge.net/dist/${name}.tar.gz";
    sha256 = "0cha71mflpa10vh2l7ipyqk67dq2y0k5xbafwdks03fwdyzj4ns8";
  };

  NIX_CFLAGS_COMPILE = if enablePIC then "-fPIC" else "";

  propagatedBuildInputs = [
    mesa freeglut SDL

    # The following libs ought to be propagated build inputs of Mesa.
    libXi libSM libXmu libXext libX11
  ];

  meta = {
    description = "PLIB: A Suite of Portable Game Libraries";

    longDescription = ''
      PLIB includes sound effects, music, a complete 3D engine, font
      rendering, a simple Windowing library, a game scripting
      language, a GUI, networking, 3D math library and a collection of
      handy utility functions.  All are 100% portable across nearly
      all modern computing platforms.  What's more, it's all available
      on line - and completely free.  Each library component is fairly
      independent of the others - so if you want to use SDL, GTK,
      GLUT, or FLTK instead of PLIB's 'PW' windowing library, you can.
    '';

    license = stdenv.lib.licenses.lgpl2Plus;

    homepage = http://plib.sourceforge.net/;
  };
}
