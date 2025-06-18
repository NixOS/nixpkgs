{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tweag-credential-helper";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = "credential-helper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yUDUvj4/Ej+7/LFGSehPK8g9Z5Il9+II8CuFt9ML+EU=";
  };

  vendorHash = "sha256-uPQwJ61ikuUjHdkqlSGhosqTjZqTSKc+TpSWblSGb0E=";

  env.CGO_ENABLED = "0";
  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [
    "cmd/credential-helper"
  ];

  postInstall = "mv $out/bin/credential-helper $out/bin/tweag-credential-helper";

  passthru.updateScript = nix-update-script { };

  # Tests currently expect to run under Bazel
  # and are not compatible with the Go test runner due to path differences.
  # The issue needs to be resolved upstream.
  doCheck = false;

  meta = {
    description = "Credential helper framework and agent for Bazel and similar tools implementing the credential-helper spec";
    homepage = "https://github.com/tweag/credential-helper";
    changelog = "https://github.com/tweag/credential-helper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "tweag-credential-helper";
    maintainers = with lib.maintainers; [
      malt3
    ];
    platforms = lib.platforms.unix;
  };
})
