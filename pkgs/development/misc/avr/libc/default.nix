{ stdenv, fetchurl, avrgcc, avrbinutils, automake, autoconf }:

let
  version = "2.0.0";
in
stdenv.mkDerivation {
  name = "avr-libc-${version}";

  src = fetchurl {
    url = http://download.savannah.gnu.org/releases/avr-libc/avr-libc-2.0.0.tar.bz2;
    sha256 = "15svr2fx8j6prql2il2fc0ppwlv50rpmyckaxx38d3gxxv97zpdj";
  };

  buildInputs = [ avrgcc avrbinutils automake autoconf ];
  configurePhase = ''
    unset LD
    unset AS
    unset AR
    unset CC
    unset CXX
    unset RANLIB
    unset STRIP

    ./configure --prefix=$out --build=$(./config.guess) --host=avr
  '';

  # Make sure we don't strip the libraries in lib/gcc/avr.
  stripDebugList= "bin";
  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "a C runtime library for AVR microcontrollers";
    homepage = http://savannah.nongnu.org/projects/avr-libc/;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mguentner ];
  };
}
