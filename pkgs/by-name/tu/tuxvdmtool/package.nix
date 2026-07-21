{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  name = "tuxvdmtool";
  version = "0.2.0-unstable-2026-03-15";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "tuxvdmtool";
    rev = "e1acae287feabb49e3ecafa56d7cbfa7c3182fc9";
    hash = "sha256-7ewIidjb8NbgTkVYLzvLICHzwb6vBph5Iu+ZgIeDZXI=";
  };

  cargoHash = "sha256-bnBtchG87ya7nlf20Zv3htnZDN5jv29DKY+8nx5CK5o=";

  __structuredAttrs = true;

  meta = {
    description = "Linux Apple Silicon to Apple Silicon VDM utility";
    homepage = "https://github.com/AsahiLinux/tuxvdmtool#readme";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mjm ];
    mainProgram = "tuxvdmtool";
    platforms = lib.platforms.linux;
  };
}
