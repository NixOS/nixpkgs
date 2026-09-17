{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "tokendiff";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "dacharyc";
    repo = "tokendiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r0o3KViGTHlIcEcgFZO/PwYU4/s7+wGPuk6Crn/y9PU=";
  };

  vendorHash = "sha256-qGINKmwu0GttbYVMz8CLf9MAOBJZtcSFXsbq392cXBc=";

  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Go library/CLI for human-readable diffs";
    mainProgram = "tokendiff";
    homepage = "https://github.com/dacharyc/tokendiff";
    maintainers = [
      lib.maintainers.mmlb
    ];
    license = lib.licenses.mit;
  };
})
