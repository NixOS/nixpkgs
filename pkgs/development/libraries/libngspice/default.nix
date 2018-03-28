{stdenv, fetchurl, bison, flex, fftw}:

# Note that this does not provide the ngspice command-line utility. For that see
# the ngspice derivation.
stdenv.mkDerivation {
  name = "libngspice-26";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-26.tar.gz";
    sha256 = "51e230c8b720802d93747bc580c0a29d1fb530f3dd06f213b6a700ca9a4d0108";
  };

  nativeBuildInputs = [ flex bison ];
  buildInputs = [ fftw ];

  configureFlags = [ "--with-ngshared" "--enable-xspice" "--enable-cider" ];

  meta = with stdenv.lib; {
    description = "The Next Generation Spice (Electronic Circuit Simulator)";
    homepage = http://ngspice.sourceforge.net;
    license = with licenses; [ "BSD" gpl2 ];
    maintainers = with maintainers; [ bgamari ];
    platforms = platforms.linux;
  };
}
