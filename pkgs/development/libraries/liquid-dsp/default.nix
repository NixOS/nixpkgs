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
<<<<<<< HEAD
  version = "1.6.0";
=======
  version = "1.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jgaeddert";
    repo = "liquid-dsp";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-3UKAwhYaYZ42+d+wiW/AB6x5TSOel8d++d3HeZqAg/8=";
=======
    sha256 = "sha256-EvCxBwzpi3riSBhlHr6MmIUYKTCp02y5gz7pDJCEC1Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
