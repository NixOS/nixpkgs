{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wac-cli";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-feXbNZZ2Ef3pkGNErZZsPNA8C8MYOOIlkiLDlJ/U3do=";
  };

  cargoHash = "sha256-Z5+RrHDlKCS66zNW+Y3RtMIpCeKV28OXO+llsz1iFYc=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "WebAssembly Composition (WAC) tooling";
    license = lib.licenses.asl20;
    homepage = "https://github.com/bytecodealliance/wac";
    maintainers = with lib.maintainers; [ water-sucks ];
    mainProgram = "wac";
  };
})
