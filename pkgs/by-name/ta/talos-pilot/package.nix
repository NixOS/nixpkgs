{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "talos-pilot";
  version = "0.1.9";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Handfish";
    repo = "talos-pilot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OZF74efMWQkZgSbOnzyygzt4pRADY1liWVpvnzWns8Y=";
  };

  cargoHash = "sha256-loCYAgZhNtYs8aBbOJMLkS9i0XglOn6BrodLQROPMPQ=";

  nativeBuildInputs = [
    protobuf
  ];
  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Talos TUI for real-time node monitoring, log streaming, etcd health, and diagnostics";
    homepage = "https://github.com/Handfish/talos-pilot";
    changelog = "https://github.com/Handfish/talos-pilot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ frantathefranta ];
    mainProgram = "talos-pilot";
  };
})
