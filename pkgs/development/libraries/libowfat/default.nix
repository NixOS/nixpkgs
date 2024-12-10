{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libowfat";
  version = "0.33";

  src = fetchurl {
    url = "https://www.fefe.de/libowfat/${pname}-${version}.tar.xz";
    sha256 = "sha256-MR7Is/S3K7RC4yP7ATqY+Vb6dFVH8ryUVih7INAnzX0=";
  };

  # Fix for glibc 2.34 from Gentoo
  # https://gitweb.gentoo.org/repo/gentoo.git/commit/?id=914a4aa87415dabfe77181a2365766417a5919a4
  postPatch = ''
    # do not define "__pure__", this the gcc builtin (bug #806505)
    sed 's#__pure__;#__attribute__((__pure__));#' -i fmt.h scan.h byte.h stralloc.h str.h critbit.h || die
    sed 's#__pure__$#__attrib__pure__#' -i  fmt.h scan.h byte.h stralloc.h str.h critbit.h || die
    # remove unneeded definition of __deprecated__
    sed '/^#define __deprecated__$/d' -i scan/scan_iso8601.c scan/scan_httpdate.c || die
  '';
  preBuild = ''
    make headers
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
