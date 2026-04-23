{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (oldAttrs: {
  pname = "yggdrasil-ng";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "Revertron";
    repo = "Yggdrasil-ng";
    tag = "v${oldAttrs.version}";
    hash = "sha256-AutOV1FXBeiG9CNoVSili3sF+QndZI2L7b72jdPOe5E=";
  };

  cargoHash = "sha256-9/whbfM5fMZT6COo2HvdCmeCFC93NI1GXhGNAAaTiLM=";

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
