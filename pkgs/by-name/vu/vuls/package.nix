{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "vuls";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "future-architect";
    repo = "vuls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RLA2TH9Ewy1Tr4JT0Ya9GKCb/tKrdWecY1Csj1olUgY=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-1fngQuwYGKGJXValuOfpN6MGBYmc99ljrU4Zhd/xUD8=";

  # `github.com/aquasecurity/trivy` 0.74 uses the Go 1.26 API of `encoding/json/v2`.
  env.GOEXPERIMENT = "jsonv2";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/future-architect/vuls/config.Version=${finalAttrs.version}"
    "-X=github.com/future-architect/vuls/config.Revision=${finalAttrs.src.rev}-1970-01-01T00:00:00Z"
  ];

  # Upstream builds `cmd/scanner` with the `scanner` build tag as `vuls-scanner`.
  excludedPackages = [ "cmd/scanner" ];

  # The test needs network access.
  checkFlags = [ "-skip=^TestAnalyzeLibrary_PomOnline$" ];

  postFixup = ''
    mv $out/bin/cmd $out/bin/trivy-to-vuls
  '';

  meta = {
    description = "Agent-less vulnerability scanner";
    homepage = "https://github.com/future-architect/vuls";
    changelog = "https://github.com/future-architect/vuls/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "vuls";
  };
})
