{ stdenv, fetchurl, libibumad }:

stdenv.mkDerivation rec {
  name = "libibmad-1.3.13";

  src = fetchurl {
    url = "https://www.openfabrics.org/downloads/management/${name}.tar.gz";
    sha256 = "02sj8k2jpcbiq8s0l2lqk4vwji2dbb2lc730cv1yzv0zr0hxgk8p";
  };

  buildInputs = [ libibumad ];

  meta = with stdenv.lib; {
    homepage = https://www.openfabrics.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
