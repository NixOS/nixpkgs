{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "matio-1.5.14";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${name}.tar.gz";
    sha256 = "0vhzh0idzlm0m28gxsnv1dcfp0229vdj49d749qn4xfdyncbnfhb";
  };

  meta = with stdenv.lib; {
    description = "A C library for reading and writing Matlab MAT files";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = http://matio.sourceforge.net/;
  };
}
