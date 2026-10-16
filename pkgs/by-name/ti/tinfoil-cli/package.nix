{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tinfoil-cli";
  version = "0.14.7";

  src = fetchFromGitHub {
    owner = "tinfoilsh";
    repo = "tinfoil-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-csFYToNR1CyVNtrXxdFJ90qAotWa/EDcRE2rvC/MG18=";
  };

  vendorHash = "sha256-VyZfBhmbH8PiY4RE7e6XFrYztSRzFo3BzFFcf4QcU34=";

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
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.haylin ];
    mainProgram = "tinfoil";
  };
})
