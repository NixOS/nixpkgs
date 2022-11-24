{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, cctools
, autoSignDarwinBinariesHook
, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  pname = "liquid-dsp";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "jgaeddert";
    repo = "liquid-dsp";
    rev = "v${version}";
    sha256 = "0mr86z37yycrqwbrmsiayi1vqrgpjq0pn1c3p1qrngipkw45jnn0";
  };

  configureFlags = lib.optionals stdenv.isDarwin [ "LIBTOOL=${cctools}/bin/libtool" ];

  nativeBuildInputs = [ autoreconfHook ]
    ++ lib.optionals stdenv.isDarwin [ cctools autoSignDarwinBinariesHook fixDarwinDylibNames ];

  meta = {
    homepage = "https://liquidsdr.org/";
    description = "Digital signal processing library for software-defined radios";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
