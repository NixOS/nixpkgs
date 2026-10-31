{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (oldAttrs: {
  pname = "yggdrasil-ng";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Revertron";
    repo = "Yggdrasil-ng";
    tag = "v${oldAttrs.version}";
    hash = "sha256-sbohqm2TXFnh03JVCzgy53lsTs1Pg/Elov3qr4mMmAI=";
  };

  cargoHash = "sha256-QdvbVSTGhV+9PF6txwiMCTNx8U20X/Fj9U1YYBvIcX8=";

  __structuredAttrs = true;

  meta = {
    mainProgram = "telemt";
    description = "Yggdrasil Network rewritten in Rust";
    homepage = "https://github.com/Revertron/Yggdrasil-ng";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      r4v3n6101
      malik
    ];
  };
})
