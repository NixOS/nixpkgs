{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tinfoil-cli";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "tinfoilsh";
    repo = "tinfoil-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fODcZaUceD03rP68UaRmo1Fu6bh9mK1UwmswS6gr/SQ=";
  };

  vendorHash = "sha256-GKR6jwBFpMO9jPsw9nquYefYGRUfL0YlRuTs45tIVKU=";

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
