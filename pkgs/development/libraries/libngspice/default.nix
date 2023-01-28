{lib, stdenv, fetchurl, bison, flex, fftw}:

# Note that this does not provide the ngspice command-line utility. For that see
# the ngspice derivation.
stdenv.mkDerivation rec {
  pname = "libngspice";
  version = "37";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-${version}.tar.gz";
    sha256 = "1gpcic6b6xk3g4956jcsqljf33kj5g43cahmydq6m8rn39sadvlv";
  };

  nativeBuildInputs = [ flex bison ];
  buildInputs = [ fftw ];

  configureFlags = [ "--with-ngshared" "--enable-xspice" "--enable-cider" ];

  meta = with lib; {
    description = "The Next Generation Spice (Electronic Circuit Simulator)";
    homepage = "http://ngspice.sourceforge.net";
    license = with licenses; [ bsd3 gpl2Plus lgpl2Plus ]; # See https://sourceforge.net/p/ngspice/ngspice/ci/master/tree/COPYING
    maintainers = with maintainers; [ bgamari ];
    platforms = platforms.unix;
  };
}
