{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tinfoil-cli";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "tinfoilsh";
    repo = "tinfoil-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1nzMNX3Xe30JFRWHmh0k+vtW1wgGqlB4ZHS9ucYyslY=";
  };

  vendorHash = "sha256-8YzNHlimaUVyrUp8pzWtfpSLDp7PxJ95/qi0ir6TSl8=";

  # The attestation test requires internet access
  checkFlags = [ "-skip=TestAttestationVerifySEV" ];

  postInstall = ''
    mv $out/bin/tinfoil-cli $out/bin/tinfoil
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line interface for making verified HTTP requests to Tinfoil enclaves and validating attestation documents";
    homepage = "https://github.com/tinfoilsh/tinfoil-cli";
    changelog = "https://github.com/tinfoilsh/tinfoil-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.haylin ];
    mainProgram = "tinfoil";
  };
})
