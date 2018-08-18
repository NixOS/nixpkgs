{ stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  name = "wavpack-${version}";
  version = "5.1.0";

  enableParallelBuilding = true;

  buildInputs = stdenv.lib.optional stdenv.isDarwin libiconv;

  src = fetchurl {
    url = "http://www.wavpack.com/${name}.tar.bz2";
    sha256 = "0i19c6krc0p9krwrqy9s5xahaafigqzxcn31piidmlaqadyn4f8r";
  };

  meta = with stdenv.lib; {
    description = "Hybrid audio compression format";
    homepage    = http://www.wavpack.com/;
    license     = licenses.bsd3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
