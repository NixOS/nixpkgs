# tts-mod-vault.nix
{
  lib,
  stdenv,
  libbar,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "tts-mod-vault";
  version = "v1.3.0";

  src = fetchFromGitHub {
    owner = "ryanbinns";
    repo = "TTS-Mod-Vault";
    rev = "v1.3.0";
    sha256 = "0vdkjlvjc5psyb0pg7080m1p1jy3y3aqhvjywfh9fm5j0zhkwfq5";
  };
}
