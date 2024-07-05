{ fetchurl, fetchpatch, lib, stdenv, libGLU, libGL, freeglut, SDL
, libXi, libSM, libXmu, libXext, libX11 }:

stdenv.mkDerivation rec {
  pname = "plib";
  version = "1.8.5";

  src = fetchurl {
    # XXX: The author doesn't use the orthodox SF way to store tarballs.
    url = "https://plib.sourceforge.net/dist/${pname}-${version}.tar.gz";
    sha256 = "0cha71mflpa10vh2l7ipyqk67dq2y0k5xbafwdks03fwdyzj4ns8";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.net/data/main/p/plib/1.8.5-7/debian/patches/04_CVE-2011-4620.diff";
      sha256 = "1b7y0vqqdzd48q68ldlzw0zzqy9mg4c10a754r4hi3ldjmcplf0j";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/p/plib/1.8.5-7/debian/patches/05_CVE-2012-4552.diff";
      sha256 = "0b6cwdwii5b5vy78sbw5cw1s96l4jyzr4dk69v63pa0wwi2b5dki";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/p/plib/1.8.5-13/debian/patches/08_CVE-2021-38714.patch";
      sha256 = "sha256-3f1wZn0QqK/hPWCg1KEzbB95IGoxBjLZoCOFlW98t5w=";
    })
  ];

  propagatedBuildInputs = [
    libGLU libGL freeglut SDL

    # The following libs ought to be propagated build inputs of Mesa.
    libXi libSM libXmu libXext libX11
  ];

  meta = {
    description = "Suite of portable game libraries";

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

    license = lib.licenses.lgpl2Plus;

    homepage = "https://plib.sourceforge.net/";
    platforms = lib.platforms.linux;
  };
}
