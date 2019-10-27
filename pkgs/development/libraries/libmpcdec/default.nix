{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "libmpcdec-1.2.6";

  src = fetchurl {
    url = https://files.musepack.net/source/libmpcdec-1.2.6.tar.bz2;
    sha256 = "1a0jdyga1zfi4wgkg3905y6inghy3s4xfs5m4x7pal08m0llkmab";
  };

  meta = {
    description = "Musepack SV7 decoder library";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.bsd3;
  };
}
