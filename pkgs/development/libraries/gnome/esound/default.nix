{input, stdenv, fetchurl, audiofile}:

assert audiofile != null;

stdenv.mkDerivation {
  inherit (input) name src;
  propagatedBuildInputs = [audiofile];
}
