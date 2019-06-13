{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "jikes-1.22";
  src = fetchurl {
    url = mirror://sourceforge/jikes/jikes-1.22.tar.bz2;
    sha256 = "1qqldrp74pzpy5ly421srqn30qppmm9cvjiqdngk8hf47dv2rc0c";
  };

  meta = {
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.epl10;
  };
}
