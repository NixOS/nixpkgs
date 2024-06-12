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
    (fetchurl {
        url = "https://sources.debian.org/data/main/d/devil/1.7.8-10/debian/patches/03_CVE-2009-3994.diff";
        sha256 = "0qkx2qfv02igbrmsn6z5a3lbrbwjfh3rb0c2sj54wy0j1f775hbc";
    })
    ./ftbfs-libpng15.patch
    ./il_endian.h.patch
  ];

  enableParallelBuilding = true;

  postPatch = ''
    for a in test/Makefile.in test/format_test/format_checks.sh.in ; do
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
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ ];
  };
})
