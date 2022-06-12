{lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "liquid-dsp";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "jgaeddert";
    repo = "liquid-dsp";
    rev = "v${version}";
    sha256 = "0mr86z37yycrqwbrmsiayi1vqrgpjq0pn1c3p1qrngipkw45jnn0";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    broken = stdenv.isDarwin;
    homepage = "https://liquidsdr.org/";
    description = "Digital signal processing library for software-defined radios";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
