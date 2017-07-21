{ stdenv, fetchurl, lcms2, jasper, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libraw-${version}";
  version = "0.17.2";

  src = fetchurl {
    url = "http://www.libraw.org/data/LibRaw-${version}.tar.gz";
    sha256 = "0p6imxpsfn82i0i9w27fnzq6q6gwzvb9f7sygqqakv36fqnc9c4j";
  };

  patches =
    [ (fetchurl {
        url = https://anonscm.debian.org/cgit/pkg-phototools/libraw.git/plain/debian/patches/0001-Fix_gcc6_narrowing_conversion.patch?id=d890937aaca6359df45a66b35e547c94ca564823;
        sha256 = "1lcg5l0wmwiyzhhm67c1c7hy8py6ihxfmicnhrwpi3i6f16vq29w";
      })
    ];

  outputs = [ "out" "lib" "dev" "doc" ];

  buildInputs = [ jasper ];

  propagatedBuildInputs = [ lcms2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Library for reading RAW files obtained from digital photo cameras (CRW/CR2, NEF, RAF, DNG, and others)";
    homepage = http://www.libraw.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}

