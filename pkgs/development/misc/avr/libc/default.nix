{ stdenv, fetchurl, automake, autoconf }:

let
  version = "2.0.0";
in
stdenv.mkDerivation {
  name = "avr-libc-${version}";

  src = fetchurl {
    url = https://download.savannah.gnu.org/releases/avr-libc/avr-libc-2.0.0.tar.bz2;
    sha256 = "15svr2fx8j6prql2il2fc0ppwlv50rpmyckaxx38d3gxxv97zpdj";
  };

  nativeBuildInputs = [ automake autoconf ];

  # Make sure we don't strip the libraries in lib/gcc/avr.
  stripDebugList = "bin";
  dontPatchELF = true;

  passthru = {
    incdir = "/avr/include";
  };

  meta = with stdenv.lib; {
    description = "a C runtime library for AVR microcontrollers";
    homepage = https://savannah.nongnu.org/projects/avr-libc/;
    license = licenses.bsd3;
    platforms = [ "avr-none" ];
    maintainers = with maintainers; [ mguentner ];
  };
}
