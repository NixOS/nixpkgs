{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
  nix-update-script,
  nixosTests,
  testers,
  thanos,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "thanos";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "thanos-io";
    repo = "thanos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iLIk5BZduSSJDocEk8a41FwrfskkijSwC0EcexjqmRA=";
  };

  vendorHash = "sha256-I99bEflBUrudb+e5A4oBQH9SktJnM96+gUaDs7yPTCM=";

  subPackages = "cmd/thanos";

  # Verify in sync with https://github.com/thanos-io/thanos/blob/main/.promu.yml
  tags = [
    "netgo"
    "slicelabels"
  ];

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-X ${t}.Version=${finalAttrs.version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
      "-X ${t}.GoVersion=${lib.getVersion go}"
    ];

  doCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) thanos;
      version = testers.testVersion {
        command = "thanos --version";
        package = thanos;
      };
    };
  };

  meta = {
    description = "Highly available Prometheus setup with long term storage capabilities";
    homepage = "https://github.com/thanos-io/thanos";
    changelog = "https://github.com/thanos-io/thanos/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "thanos";
    maintainers = with lib.maintainers; [
      basvandijk
      anthonyroussel
    ];
  };
})
