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
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    tag = finalAttrs.version;
    hash = "sha256-tOsyPBpZaotlwzV1atW9FnfFbemtR3v51cg7UFIwI6U=";
  };

  cargoHash = "sha256-C1PkpKYsb62s6H4VgRSo7WzHFBaUv1Yk6IXm9ep20p8=";

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
