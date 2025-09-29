# tts-mod-vault.nix
{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "tts-mod-vault";
  version = "1.3.0";

  src = fetchFromGitHub {

    owner = "markomijic";
    repo = "TTS-Mod-Vault";
    rev = "v${version}";
    hash = "sha256-BTs+4QeyVJeg415uiNXww8twQwUInHfB8voWJjeVs20=";
  };

  nativeBuildInputs = [ cmake ];

  configurePhase = {

  };

  buildPhase = {

  };

  installPhase = ''
    mkdir -p $out/bin
    cp tts-mod-vault $out/bin
  '';

  meta = with lib; {
    description = "TTS Mod Vault is a cross-platform mod backup tool for your Tabletop Simulator mods, saves and saved objects on Windows, Linux, and macOS.";
    homepage = "https://github.com/markomijic/TTS-Mod-Vault";
    license = lib.licenses.gpl3Only;
    mainProgram = "TTS-Mod-Vault";
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ esch ];
  };
}
