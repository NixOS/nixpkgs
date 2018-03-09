{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "matio-1.5.11";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${name}.tar.gz";
    sha256 = "02ygr7bslzvn6mhxvapz57bh4d448xjf3ds82g1cvhn9al6fvk0c";
  };

  meta = with stdenv.lib; {
    description = "A C library for reading and writing Matlab MAT files";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = http://matio.sourceforge.net/;
  };
}
