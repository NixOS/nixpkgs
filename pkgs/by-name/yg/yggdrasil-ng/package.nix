{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (oldAttrs: {
  pname = "yggdrasil-ng";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "Revertron";
    repo = "Yggdrasil-ng";
    tag = "v${oldAttrs.version}";
    hash = "sha256-nJLK5O2kjFRGZ3JwqwLHtYqvJfrOxtZOjdM6q2NNrbk=";
  };

  cargoHash = "sha256-mJr8IMTbB+mSrsxzq6ehnfBueulNqZtxU/1aHAyv954=";

  __structuredAttrs = true;

  meta = {
    mainProgram = "telemt";
    description = "Yggdrasil Network rewritten in Rust";
    homepage = "https://github.com/Revertron/Yggdrasil-ng";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [
      r4v3n6101
      malik
    ];
  };
})
