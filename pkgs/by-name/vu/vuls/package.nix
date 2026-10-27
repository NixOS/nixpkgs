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

  # The vendored `github.com/aquasecurity/trivy` 0.74 imports `encoding/json/v2`.
  # Go 1.26 has this package only with `GOEXPERIMENT=jsonv2`, and trivy 0.74
  # uses its Go 1.26 API. Without it, `buildGoModule` skips `cmd/vuls` and the
  # other packages that import trivy. Upstream also builds with this setting.
  env.GOEXPERIMENT = "jsonv2";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/future-architect/vuls/config.Version=${finalAttrs.version}"
    "-X=github.com/future-architect/vuls/config.Revision=${finalAttrs.src.rev}-1970-01-01T00:00:00Z"
  ];

  # `cmd/scanner` imports trivy, thus it builds only with `GOEXPERIMENT`.
  # Upstream builds it with the `scanner` build tag as `vuls-scanner`.
  excludedPackages = [ "cmd/scanner" ];

  # The `scanner` package imports trivy, thus its tests run only with
  # `GOEXPERIMENT`. This test needs network access.
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
