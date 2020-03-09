{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "libfpx-1.3.1-7";

  src = fetchurl {
    url = "mirror://imagemagick/delegates/${name}.tar.xz";
    sha256 = "1s28mwb06w6dj0zl6ashpj8m1qiyadawzl7cvbw7dmj1w39ipghh";
  };

  # Darwin gets misdetected as Windows without this
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-D__unix";

  patches = [
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-libs/libfpx/files/libfpx-1.3.1_p6-gcc6.patch?id=f28a947813dbc0a1fd1a8d4a712d58a64c48ca01";
      sha256 = "032y8110zgnkdhkdq3745zk53am1x34d912rai8q70k3sskyq22p";
    })
  ];

  # This dead code causes a duplicate symbol error in Clang so just remove it
  postPatch = if stdenv.cc.isClang then ''
    substituteInPlace jpeg/ejpeg.h --replace "int No_JPEG_Header_Flag" ""
  '' else null;

  meta = with stdenv.lib; {
    homepage = http://www.imagemagick.org;
    description = "A library for manipulating FlashPIX images";
    license = "Flashpix";
    platforms = platforms.all;
  };
}
