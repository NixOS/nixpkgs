{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ting";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "dhth";
    repo = "ting";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D5u/zRjUu+fku6MdtBuwjYQqCkaQbI4sN0UR5NLFN8c=";
  };

  cargoHash = "sha256-17hmYsbOOJcrepwI4Q6VuB42SF7ec+BJYTlGKmxkL5w=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsa-lib ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Audio feedback on the command line";
    homepage = "https://github.com/dhth/ting";
    changelog = "https://github.com/dhth/ting/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "ting";
    platforms = lib.platforms.linux;
  };
})
