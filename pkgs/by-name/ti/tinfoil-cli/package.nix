{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tinfoil-cli";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "tinfoilsh";
    repo = "tinfoil-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ET6fPEE6LKbB3UmMgSGC9/EuzdmNRe4ELmJegrWJpZU=";
  };

  vendorHash = "sha256-b6UmayV913SVyV5+1BMZiRM7SV/Asau6xkx87DWTf9k=";

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
