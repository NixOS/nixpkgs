{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tinfoil-cli";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "tinfoilsh";
    repo = "tinfoil-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EgrFHyOW1mY49oOhYNb9uyiM6wV/Z/sWmh5jL86OY+8=";
  };

  vendorHash = "sha256-uwryZGob/sGcUzz0JwdbwGBbwp0SmVFfl6pGcGiocAI=";

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
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.haylin ];
    mainProgram = "tinfoil";
  };
})
