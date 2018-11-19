{stdenv, fetchurl, bison, flex, fftw}:

# Note that this does not provide the ngspice command-line utility. For that see
# the ngspice derivation.
stdenv.mkDerivation {
  name = "libngspice-29";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-29.tar.gz";
    sha256 = "0jjwz73naq7l9yhwdqbpnrfckywp2ffkppivxjv8w92zq7xhyvcd";
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
