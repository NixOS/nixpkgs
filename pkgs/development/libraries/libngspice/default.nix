{stdenv, fetchurl, bison, flex, fftw}:

# Note that this does not provide the ngspice command-line utility. For that see
# the ngspice derivation.
stdenv.mkDerivation {
  name = "libngspice-27";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-27.tar.gz";
    sha256 = "15862npsy5sj56z5yd1qiv3y0fgicrzj7wwn8hbcy89fgbawf20c";
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
