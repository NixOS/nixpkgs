{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "telemt";
  version = "3.4.5";

  src = fetchFromGitHub {
    owner = "telemt";
    repo = "telemt";
    tag = finalAttrs.version;
    hash = "sha256-zOdVnW7RTPAbR6fpzDqPpwhOWjxknmg8TzGXmBCbWjg=";
  };

  cargoHash = "sha256-/7Xd/6NEu6QqFdVUz4M+iz9+7K5lEDguyaprAKh86wo=";

  meta = {
    mainProgram = "telemt";
    description = "MTProxy for Telegram";
    homepage = "https://github.com/telemt/telemt";
    license = {
      shortName = "telemt-license";
      fullName = "TELEMT Public License 3";
      url = "https://github.com/telemt/telemt/blob/main/LICENSE";
      free = false;
    };
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      c0bectb
      r4v3n6101
    ];
  };
})
