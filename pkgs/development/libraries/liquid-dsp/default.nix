{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  cctools,
  autoSignDarwinBinariesHook,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation rec {
  pname = "liquid-dsp";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "jgaeddert";
    repo = "liquid-dsp";
    rev = "v${version}";
    sha256 = "sha256-OdtTxAWZckOd0iBHstmDJEuFtBh3PSdY1MqOepvnNTA=";
  };

  configureFlags = lib.optionals stdenv.hostPlatform.isDarwin [ "LIBTOOL=${cctools}/bin/libtool" ];

  nativeBuildInputs =
    [ autoreconfHook ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools
      autoSignDarwinBinariesHook
      fixDarwinDylibNames
    ];

  meta = {
    homepage = "https://liquidsdr.org/";
    description = "Digital signal processing library for software-defined radios";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
