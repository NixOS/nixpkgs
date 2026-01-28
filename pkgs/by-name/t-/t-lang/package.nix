{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "t-lang";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "alecthomas";
    repo = "t";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZNZc8B0F2z0C5WRoq2YD/dciJNl64ScOA3p4yNOwe9A=";
  };

  cargoHash = "sha256-Vpisck1TMU3iubfA77DSBExEnwtVV/eibcC+qMR0+Y8=";

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
