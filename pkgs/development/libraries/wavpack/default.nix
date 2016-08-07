{ lib, stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  name = "wavpack-${version}";
  version = "4.80.0";

  enableParallelBuilding = true;

  buildInputs = stdenv.lib.optional stdenv.isDarwin libiconv;

  src = fetchurl {
    url = "http://www.wavpack.com/${name}.tar.bz2";
    sha256 = "1sbbwvqixg87h02avg0d5r64mpjz8cmhcc6j3s9wmlbvbykjw63r";
  };

  meta = with stdenv.lib; {
    description = "Hybrid audio compression format";
    homepage    = http://www.wavpack.com/;
    license     = licenses.bsd3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
