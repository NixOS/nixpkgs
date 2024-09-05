{ lib
, stdenv
, fetchurl
, cmake
, libjpeg
, libpng
, libmng
, lcms1
, libtiff
, openexr
, libGL
, libX11
, pkg-config
, OpenGL
, runtimeShell
, withXorg ? true
, testers
, mesa
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdevil";
  version = "1.8.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://sourceforge/openil/DevIL-${finalAttrs.version}.tar.gz";
    hash = "sha256-AHWXPufdifBQeHPiWArHgzZFLSnTSgcTSyCPROL+twk=";
  };

  sourceRoot = "DevIL/DevIL";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libjpeg libpng libmng lcms1 libtiff openexr ]
    ++ lib.optionals withXorg [ libX11 libGL ]
    ++ lib.optionals stdenv.isDarwin [ OpenGL ];

  configureFlags = [ "--enable-ILU" "--enable-ILUT" ];

  CXXFLAGS = lib.optionalString stdenv.cc.isClang "-Wno-register";

  preConfigure = ''
    sed -i 's,malloc.h,stdlib.h,g' src-ILU/ilur/ilur.c
  '';

  patches = [
    ./0001-il_endian.h-Fix-endian-handling.patch
  ];

  enableParallelBuilding = true;

  postPatch = ''
    for a in test/Makefile.am test/format_test/format_checks.sh.in ; do
      substituteInPlace $a \
        --replace /bin/bash ${runtimeShell}
    done
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    homepage = "https://openil.sourceforge.net/";
    description = "Image library which can can load, save, convert, manipulate, filter and display a wide variety of image formats";
    mainProgram = "ilur";
    license = licenses.lgpl2;
    pkgConfigModules = [ "IL" ];
    inherit (mesa.meta) platforms;
    maintainers = [ ];
  };
})
