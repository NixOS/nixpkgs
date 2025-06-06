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
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "jgaeddert";
    repo = "liquid-dsp";
    rev = "v${version}";
    sha256 = "sha256-3UKAwhYaYZ42+d+wiW/AB6x5TSOel8d++d3HeZqAg/8=";
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
