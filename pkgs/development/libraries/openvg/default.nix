{ lib
, stdenv
, fetchFromGitHub
, cmake
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
      #libGL # -> libglvnd
      libGLU
      freeglut
      libglvnd # GL/glx.h
      glew
      libjpeg
      xlibs.libX11 # X11/Xlib.h for GL/glx.h
    ];

    src = fetchFromGitHub {
      owner = "vpxyz";
      repo = "ShivaVG";
      rev = "e0da00336ae731ad76d93312a8542a079a39cd9d";
      sha256 = "IrzIMggjwoEppJ0pL+vrPbRpo3anvxt/784AZYD5eXo=";
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
}
