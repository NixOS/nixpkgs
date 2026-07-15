{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (oldAttrs: {
  pname = "yggdrasil-ng";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Revertron";
    repo = "Yggdrasil-ng";
    tag = "v${oldAttrs.version}";
    hash = "sha256-Ic3r8xNeBMg+vN9C2JPRrpVRNHqT5XuDT+EoD493qdM=";
  };

  cargoHash = "sha256-eA5tXPqZJnRIYQGxmjOA8esDV8u74afWMfZ9bn9PsWE=";

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
