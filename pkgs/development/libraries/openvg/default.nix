{ lib
, stdenv
, fetchFromGitHub
, cmake
, autoconf
, automake
, libtool
, libGL
, libGLU
, freeglut
, libglvnd
, glew
, xlibs
, libjpeg
, mmv # mcp
}:

rec {
  shivavg = stdenv.mkDerivation rec {
    pname = "shivavg";
    version = "0.2.1-e0da003";

    nativeBuildInputs = [ cmake ];

    buildInputs = [
      libGLU
      freeglut
      libglvnd # GL/glx.h
      glew
      libjpeg
      xlibs.libX11 # X11/Xlib.h for GL/glx.h
    ];

    src = fetchFromGitHub {
      /*
      owner = "vpxyz";
      repo = "ShivaVG";
      rev = "e0da00336ae731ad76d93312a8542a079a39cd9d";
      sha256 = "IrzIMggjwoEppJ0pL+vrPbRpo3anvxt/784AZYD5eXo=";
      */
      # https://github.com/vpxyz/ShivaVG/pull/4
      owner = "milahu";
      repo = "ShivaVG";
      rev = "a30c5bce2c6ca0d17f230b6c65687e452536f90a";
      sha256 = "stMJ8e02q+shZAsfCD9rC7CVnoVcs9gGH7Ym92PJHB0=";
    };

    cmakeFlags = [ "-DBUILD_ALL_EXAMPLES=no" ]; # 20 seconds vs 320 seconds

    meta = with lib; {
      description = "OpenVG implementation, based on OpenGL";
      homepage    = "https://github.com/vpxyz/ShivaVG";
      platforms   = platforms.linux;
      license     = licenses.lgpl2Only;
      #maintainers = [ maintainers.TODO ];
    };
  };

  shivavg-examples = shivavg.overrideAttrs (shivavg: {
    # TODO link to shivavg/lib/libOpenVG.so
    nativeBuildInputs = shivavg.nativeBuildInputs ++ [ mmv ];
    pname = "shivavg-examples";
    cmakeFlags = [];
    postInstall = ''
      mkdir $out/bin
      mcp "examples/test_*" "$out/bin/shivavg-example-#1"
    '';
  });

  monkvg = stdenv.mkDerivation rec {
    pname = "monkvg";
    version = "2a04624";

    nativeBuildInputs = [ autoconf automake libtool ];
    buildInputs = [
      # TODO libGL -> libglvnd?
      libGL
      libGLU
      glew
    ];

    src = fetchFromGitHub {
      owner = "micahpearlman";
      repo = "MonkVG";
      rev = "2a04624e7dd14d53cd1b7e828bd0f6aea689aeba";
      sha256 = "KpQ82ZHjmH+toonmt+M/YCnw/crhb0OlzPKUO729THU=";
      # 2 commits ahead: https://github.com/pwiecz/MonkVG/commits/master
    };

    # type conflict. guess: openGL desktop uses double, not float
    # https://github.com/micahpearlman/MonkVG/issues/47
    patchPhase = ''
      sed -i 's|typedef float GLdouble;|typedef double GLdouble;|' glu/include/glu.h
      sed -i -E 's,(^|[^a-zA-Z])float ([a-zA-Z0-9]+\[(4|16)\]),\1GLdouble \2,' glu/libutil/project.c
      sed -i -E 's,GLclampd (nearVal|farVal),GLdouble \1,g' glu/libutil/project.c
    '';

    preConfigure = ''
      cd projects/MonkVG-autotools
      autoreconf -vfi
    '';

    meta = with lib; {
      description = "OpenVG implementation, based on OpenGL ES";
      homepage    = "https://github.com/micahpearlman/MonkVG";
      platforms   = platforms.linux;
      license     = licenses.bsd3;
      #maintainers = [ maintainers.TODO ];
    };
  };
}
