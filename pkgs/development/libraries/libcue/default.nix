{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "libcue-1.3.0";
  src = fetchurl {
    url = "mirror://sourceforge/libcue/${name}.tar.bz2";
    sha256 = "0gcd9maxh82fc0qah0q8xh74sch0px3n7c0qx0298n2qbk2mkn12";
  };
  meta = {
    description = "A library to parse a cue sheet";
    longDescription = ''
      libcue is intended to parse a so called cue sheet from a char string or
      a file pointer. For handling of the parsed data a convenient API is
      available.
    '';
    homepage = http://sourceforge.net/projects/libcue/;
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
