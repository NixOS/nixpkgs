{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libowfat";
  version = "0.32";

  src = fetchurl {
    url = "https://www.fefe.de/libowfat/${pname}-${version}.tar.xz";
    sha256 = "1hcqg7pvy093bxx8wk7i4gvbmgnxz2grxpyy7b4mphidjbcv7fgl";
  };

  patches = [
    (fetchurl {
      name = "first_deferred.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-libs/libowfat/files/libowfat-0.32-gcc10.patch?id=129f4ab9f8571c651937c46ba7bd4c82d6d052a2";
      sha256 = "zxWb9qq5dkDucOsiPfGG1Gb4BZ6HmhBjgSe3tBnydP4=";
    })
  ];

  # Fix for glibc 2.34 from Gentoo
  # https://gitweb.gentoo.org/repo/gentoo.git/commit/?id=914a4aa87415dabfe77181a2365766417a5919a4
  postPatch = ''
    # do not define "__pure__", this the gcc builtin (bug #806505)
    sed 's#__pure__;#__attribute__((__pure__));#' -i fmt.h scan.h byte.h stralloc.h str.h critbit.h || die
    sed 's#__pure__$#__attrib__pure__#' -i  fmt.h scan.h byte.h stralloc.h str.h critbit.h || die
    # remove unneeded definition of __deprecated__
    sed '/^#define __deprecated__$/d' -i scan/scan_iso8601.c scan/scan_httpdate.c || die
  '';

  makeFlags = [ "prefix=$(out)" ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "A GPL reimplementation of libdjb";
    homepage = "https://www.fefe.de/libowfat/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
