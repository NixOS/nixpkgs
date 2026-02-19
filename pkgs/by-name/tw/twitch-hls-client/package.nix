{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "twitch-hls-client";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "2bc4";
    repo = "twitch-hls-client";
    rev = finalAttrs.version;
    hash = "sha256-jApBFe9GeXkkNO+oODpYt+FArsU441lJhxnwzL4vwPk=";
  };

  cargoHash = "sha256-MYuDQMxUqKbgGVC/vFRcYJhjL5e8v+5zA0SYRaBlJaw=";

  meta = {
    description = "Minimal CLI client for watching/recording Twitch streams";
    homepage = "https://github.com/2bc4/twitch-hls-client.git";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lenivaya ];
    mainProgram = "twitch-hls-client";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = lib.platforms.all;
  };
})
