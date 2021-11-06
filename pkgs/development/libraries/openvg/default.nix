# TODO add amanithvg

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
  shivavg =
  let
    owner = "vpxyz";
    repo = "ShivaVG";
    rev = "35e58010f3662b21b6632bbe55988dc18070534c";
    sha256 = "1TGKdXUKZ35tft0fA+IvKP4668rZM/PvYDmcgcb33RQ=";
  in
  stdenv.mkDerivation rec {
    pname = "shivavg";
    version = "0.2.1-${builtins.substring 0 7 rev}";

    nativeBuildInputs = [ cmake ];

    buildInputs = [
      libGLU
      freeglut
      libglvnd
      glew
      libjpeg
      xlibs.libX11
    ];

    src = fetchFromGitHub {
      inherit owner repo rev sha256;
    };

    cmakeFlags = [
      "-DSHARED_LIBRARY_NAME=ShivaVG"
      "-DSTATIC_LIBRARY_NAME=ShivaVG"
      # default is OpenVG
    ];

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
      libglvnd
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
