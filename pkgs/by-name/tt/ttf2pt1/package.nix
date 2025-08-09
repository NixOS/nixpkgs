{
  lib,
  stdenv,
  fetchurl,
  perl,
  freetype,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ttf2pt1";
  version = "3.4.4";

  src = fetchurl {
    url = "mirror://sourceforge/ttf2pt1/ttf2pt1-${finalAttrs.version}.tgz";
    sha256 = "1l718n4k4widx49xz7qrj4mybzb8q67kp2jw7f47604ips4654mf";
  };

  preConfigure = ''
    find -type f | xargs sed -i 's@/usr/bin/perl@${perl}/bin/perl@'
    mkdir -p $out
    sed -e 's/chown/true/' \
        -e 's/chgrp/true/' \
        -e 's@^CFLAGS_FT =.*@CFLAGS_FT=-DUSE_FREETYPE -I${freetype.dev}/include/freetype2@' \
        -i scripts/{inst_dir,inst_file} Makefile
    makeFlags="INSTDIR=$out OWNER=`id -u`"
  '';

  buildInputs = [ freetype ];
  nativeBuildInputs = [ perl ];

  patches = [
    ./gentoo-makefile.patch # also contains the freetype patch

    # fix build with c99
    # https://src.fedoraproject.org/rpms/ttf2pt1/c/070de5269475785d27ae7996513bee12cb9a0f53
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/ttf2pt1/raw/070de5269475785d27ae7996513bee12cb9a0f53/f/ttf2pt1-c99.patch";
      hash = "sha256-7+RnExqxED+fUJSj3opfYi0eQ5zqswOZnKjQMvlF020=";
    })

    # fix build with gcc14
    # https://src.fedoraproject.org/rpms/ttf2pt1/c/1ebb612acb7088095c6bd7242209f0ce848895fb
    ./ttf2pt1-gcc14.patch
  ];

  meta = {
    description = "True Type to Postscript Type 3 converter, fpdf";
    homepage = "https://ttf2pt1.sourceforge.net/index.html";
    license = "ttf2pt1";
    platforms = lib.platforms.linux;
  };
})
