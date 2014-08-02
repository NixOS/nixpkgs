{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "libcue-1.4.0";
  src = fetchurl {
    url = "mirror://sourceforge/libcue/${name}.tar.bz2";
    sha256 = "17kjd7rjz1bvfn44n3n2bjb7a1ywd0yc0g4sqp5ihf9b5bn7cwlb";
  };
  meta = {
    description = "A library to parse a cue sheet";
    longDescription = ''
      libcue is intended to parse a so called cue sheet from a char string or
      a file pointer. For handling of the parsed data a convenient API is
      available.
    '';
    homepage = http://sourceforge.net/projects/libcue/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
