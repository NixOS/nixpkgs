{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tweag-credential-helper";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = "credential-helper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7Aja88JAhBIL5m1I7GEVjHnVA1rAoAr/7JN8GVQ90w8=";
  };

  vendorHash = "sha256-LVXHCRgRop2wdNU/NG5FFVYf5iiQRSPoRSX7B7r2tuI=";

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
