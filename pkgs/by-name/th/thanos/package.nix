{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
  nix-update-script,
  nixosTests,
  testers,
  thanos,
}:

buildGoModule rec {
  pname = "thanos";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "thanos-io";
    repo = "thanos";
    tag = "v${version}";
    hash = "sha256-3rNtiVTrA+MoCVuTSLIzh65U0kjA86EF+bQCyfVa6rA=";
  };

  vendorHash = "sha256-Z/S4mVg+VbP8hNVB1xz1uGWR6N/1aTA0DqTHbntGMLg=";

  subPackages = "cmd/thanos";

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
      "-X ${t}.GoVersion=${lib.getVersion go}"
    ];

  doCheck = true;

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
    changelog = "https://github.com/thanos-io/thanos/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "thanos";
    maintainers = with lib.maintainers; [
      basvandijk
      anthonyroussel
    ];
  };
}
