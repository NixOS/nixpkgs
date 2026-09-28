{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "tailcat";
  version = "0.6.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailcat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TwrEezNpn9ylDl7+Vo4XS/SaVOgU6h6PO1UWSrXnBWk=";
  };

  vendorHash = "sha256-hpFVgsUKswE7g69EieoeKGPR1nVkcRmBhDKbnB2CDBg=";

  subPackages = [ "cmd/tailcat" ];

  # Build with the same tags as the official release binaries. The
  # comma-separated list lives in build-tags.txt in the source tree
  # (see build-tags.md there); it omits unused tailscale.com library
  # features to shrink the binary.
  preBuild = ''
    IFS=, read -ra tags < build-tags.txt
  '';

  ldflags = [
    "-s"
    "-X main.version=v${finalAttrs.version}"
  ];

  env.CGO_ENABLED = "0";

  # The release tags apply only to the binary. Vendored test helpers
  # do not compile with the omit tags, and upstream CI runs go test
  # without them.
  preCheck = ''
    unset tags
  '';

  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Like netcat, but over Tailscale's data plane, without Tailscale's control plane";
    homepage = "https://github.com/tailscale/tailcat";
    changelog = "https://github.com/tailscale/tailcat/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sophronesis ];
    mainProgram = "tailcat";
  };
})
