{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wttrbar";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    tag = finalAttrs.version;
    hash = "sha256-VAKx5FzVWZe3VFvkwya1K+2/IJaPjHy0SBNyWQq6GLI=";
  };

  cargoHash = "sha256-gsxVb/4CJzu18LIIhg0G6zf3U27HhsKa/NgZhbR0RL0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple but detailed weather indicator for Waybar using wttr.in";
    homepage = "https://github.com/bjesus/wttrbar";
    changelog = "https://github.com/bjesus/wttrbar/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "wttrbar";
  };
})
