{ lib, stdenv, fetchurl, fetchFromGitHub, cmake, pkgconfig, xorg, mesa_glu
, mesa_noglu, glew, ocl-icd, python3
, cudaSupport ? false, cudatoolkit
}:

stdenv.mkDerivation rec {
  name = "opensubdiv-${version}";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "PixarAnimationStudios";
    repo = "OpenSubdiv";
    rev = "v${lib.replaceChars ["."] ["_"] version}";
    sha256 = "0wk12n1s8za3sz8d6bmfm3rfjyx20j48gy1xp57dvbnjvlvzqy3w";
  };

  outputs = [ "out" "dev" ];

  buildInputs =
    [ cmake pkgconfig mesa_glu mesa_noglu ocl-icd python3
      # FIXME: these are not actually needed, but the configure script wants them.
      glew xorg.libX11 xorg.libXrandr xorg.libXxf86vm xorg.libXcursor
      xorg.libXinerama xorg.libXi
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

  postInstall = "rm $out/lib/*.a";

  meta = {
    description = "An Open-Source subdivision surface library";
    homepage = http://graphics.pixar.com/opensubdiv;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.eelco ];
    license = lib.licenses.asl20;
  };
}
