{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uniqtoo";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "JakeWharton";
    repo = "uniqtoo";
    tag = finalAttrs.version;
    hash = "sha256-Gu5nkSavZuowayLVS2c1eQKeJQ6cDjoiM4M1/3U/LTA=";
  };

  cargoHash = "sha256-PwEplSiFw+MNY61V2q9EhyYARQuaHvZ74Iv41dTVWIY=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A version of `sort | uniq -c` with output that updates in real-time as each line is parsed";
    homepage = "https://github.com/JakeWharton/uniqtoo";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ starsep ];
  };
})
