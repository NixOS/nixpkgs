{ lib, stdenv, fetchurl, automake, autoconf }:

stdenv.mkDerivation rec {
  pname = "avr-libc";
  version = "2.2.0";

  tag_version = builtins.replaceStrings ["."] ["_"] version;
  src = fetchurl {
    url = "https://github.com/avrdudes/avr-libc/releases/download/avr-libc-${tag_version}-release/avr-libc-${version}.tar.bz2";
    hash = "sha256-Bxjv1PVCeId9ploLIDtAIHOzDgTf6piObyqINa0HHTU=";
  };

  nativeBuildInputs = [ automake autoconf ];

  # Make sure we don't strip the libraries in lib/gcc/avr.
  stripDebugList = [ "bin" ];
  dontPatchELF = true;

  enableParallelBuilding = true;

  passthru = {
    incdir = "/avr/include";
  };

  meta = with lib; {
    description = "C runtime library for AVR microcontrollers";
    homepage = "https://github.com/avrdudes/avr-libc";
    license = licenses.bsd3;
    platforms = [ "avr-none" ];
    maintainers = with maintainers; [ mguentner emilytrau ];
  };
}
