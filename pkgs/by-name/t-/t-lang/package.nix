{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "t-lang";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "alecthomas";
    repo = "t";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J/lQ5x72Z6yv/F0+n9tMLsIP4ojrbZKuUajPlvMnBsU=";
  };

  cargoHash = "sha256-86T8rOKXx6agZw6xu10YVCgP+dyuodCW1ZZlimQFcFk=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Text processing language and utility";
    longDescription = ''
      T is a concise language for manipulating text, replacing common usage
      patterns of Unix utilities like grep, sed, cut, awk, sort, and uniq.
    '';
    homepage = "https://github.com/alecthomas/t";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chillcicada ];
    mainProgram = "t";
  };
})
