{ lib, stdenv, fetchurl, fetchFromGitHub, cmake, pkgconfig, xorg, mesa, glew
, cudaSupport ? false, cudatoolkit
}:

stdenv.mkDerivation {
  name = "opensubdiv-3.0.4";

  src = fetchFromGitHub {
    owner = "PixarAnimationStudios";
    repo = "OpenSubdiv";
    rev = "v3_0_4";
    sha256 = "14ylpzk4121gi3fl02dwmqjp5sbaqpkm4gd0lh6jijccdih0xsc0";
  };

  patches =
    [ # Fix for building with cudatoolkit 7.
      (fetchurl {
        url = "https://github.com/opeca64/OpenSubdiv/commit/c3c258d00feaeffe1123f6077179c155e71febfb.patch";
        sha256 = "0vazhp35v8vsgnvprkzwvfkbalr0kzcwlin9ygyfb77cz7mwicnf";
      })
    ];

  buildInputs =
    [ cmake pkgconfig mesa
      # FIXME: these are not actually needed, but the configure script wants them.
      glew xorg.libX11 xorg.libXrandr xorg.libXxf86vm xorg.libXcursor xorg.libXinerama
    ]
    ++ lib.optional cudaSupport cudatoolkit;

  cmakeFlags =
    [ "-DNO_TUTORIALS=1"
      "-DNO_REGRESSION=1"
      "-DNO_EXAMPLES=1"
      "-DGLEW_INCLUDE_DIR=${glew}/include"
      "-DGLEW_LIBRARY=${glew}/lib"
    ];

  enableParallelBuilding = true;

  meta = {
    description = "An Open-Source subdivision surface library";
    homepage = http://graphics.pixar.com/opensubdiv;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.eelco ];
    license = lib.licenses.asl20;
  };
}
