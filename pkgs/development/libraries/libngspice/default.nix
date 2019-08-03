{stdenv, fetchurl, bison, flex, fftw}:

# Note that this does not provide the ngspice command-line utility. For that see
# the ngspice derivation.
stdenv.mkDerivation rec {
  name = "libngspice-${version}";
  version = "30";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-${version}.tar.gz";
    sha256 = "15v0jdfy2a2zxp8dmy04fdp7w7a4vwvffcwa688r81b86wphxzh8";
  };

  nativeBuildInputs = [ flex bison ];
  buildInputs = [ fftw ];

  configureFlags = [ "--with-ngshared" "--enable-xspice" "--enable-cider" ];

  meta = with stdenv.lib; {
    description = "The Next Generation Spice (Electronic Circuit Simulator)";
    homepage = http://ngspice.sourceforge.net;
    license = with licenses; [ bsd3 gpl2Plus lgpl2Plus ]; # See https://sourceforge.net/p/ngspice/ngspice/ci/master/tree/COPYING
    maintainers = with maintainers; [ bgamari ];
    platforms = platforms.linux;
  };
}
