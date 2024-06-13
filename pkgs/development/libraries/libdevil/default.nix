{ lib
, stdenv
, fetchurl
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
  version = "1.7.8";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://sourceforge/openil/DevIL-${finalAttrs.version}.tar.gz";
    sha256 = "1zd850nn7nvkkhasrv7kn17kzgslr5ry933v6db62s4lr0zzlbv8";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libjpeg libpng libmng lcms1 libtiff openexr ]
    ++ lib.optionals withXorg [ libX11 libGL ]
    ++ lib.optionals stdenv.isDarwin [ OpenGL ];

  configureFlags = [ "--enable-ILU" "--enable-ILUT" ];

  CXXFLAGS = lib.optionalString stdenv.cc.isClang "-Wno-register";

  preConfigure = ''
    sed -i 's, -std=gnu99,,g' configure
    sed -i 's,malloc.h,stdlib.h,g' src-ILU/ilur/ilur.c
  '' + lib.optionalString stdenv.cc.isClang ''
    sed -i 's/libIL_la_CXXFLAGS = $(AM_CFLAGS)/libIL_la_CXXFLAGS =/g' lib/Makefile.in
  '';

  postConfigure = ''
    sed -i '/RESTRICT_KEYWORD/d' include/IL/config.h
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
