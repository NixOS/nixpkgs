{ stdenv, fetchurl, autoconf, g77, texinfo, bison, flex, gperf }:

assert autoconf != null && texinfo != null
  && bison != null && flex != null && gperf != null;
assert g77.langF77;

stdenv.mkDerivation {
  name = "octave-2.1.57";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.octave.org/pub/octave/bleeding-edge/octave-2.1.57.tar.gz ;
    md5 = "a0171814e005ce6d77365e7d831eef45";
  };
  inherit autoconf g77 texinfo bison flex gperf;
}
