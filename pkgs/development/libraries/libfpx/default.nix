{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libfpx-1.3.1-7";

  src = fetchurl {
    url = "mirror://imagemagick/delegates/${name}.tar.xz";
    sha256 = "1s28mwb06w6dj0zl6ashpj8m1qiyadawzl7cvbw7dmj1w39ipghh";
  };

  # Darwin gets misdetected as Windows without this
  NIX_CFLAGS_COMPILE = if stdenv.isDarwin then "-D__unix" else null;

  # This dead code causes a duplicate symbol error in Clang so just remove it
  postPatch = if stdenv.cc.isClang then ''
    substituteInPlace jpeg/ejpeg.h --replace "int No_JPEG_Header_Flag" ""
  '' else null;

  meta = with stdenv.lib; {
    homepage = http://www.imagemagick.org;
    description = "A library for manipulating FlashPIX images";
    license = "Flashpix";
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
