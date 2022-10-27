{ lib, stdenv, fetchurl, automake, autoconf }:

stdenv.mkDerivation rec {
  pname = "avr-libc";
  version = "2.1.0";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/avr-libc/avr-libc-${version}.tar.bz2";
    sha256 = "1s2lnqsbr1zs7dvsbyyckay52lm8mbjjaqf3cyx5qpcbq3jwx10b";
  };

  nativeBuildInputs = [ automake autoconf ];

  # Make sure we don't strip the libraries in lib/gcc/avr.
  stripDebugList = [ "bin" ];
  dontPatchELF = true;

  passthru = {
    incdir = "/avr/include";
  };

  meta = with lib; {
    description = "a C runtime library for AVR microcontrollers";
    homepage = "https://github.com/avrdudes/avr-libc";
    license = licenses.bsd3;
    platforms = [ "avr-none" ];
    maintainers = with maintainers; [ mguentner emilytrau ];
  };
}
