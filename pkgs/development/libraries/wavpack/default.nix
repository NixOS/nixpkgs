{ stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  pname = "wavpack";
  version = "5.2.0";

  enableParallelBuilding = true;

  buildInputs = stdenv.lib.optional stdenv.isDarwin libiconv;

  src = fetchurl {
    url = "http://www.wavpack.com/${pname}-${version}.tar.bz2";
    sha256 = "062f97bvm466ygvix3z0kbgffvvrc5cg2ak568jaq8r56v28q8rw";
  };

  meta = with stdenv.lib; {
    description = "Hybrid audio compression format";
    homepage    = http://www.wavpack.com/;
    license     = licenses.bsd3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
