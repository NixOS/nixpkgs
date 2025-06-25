{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "VictoriaLogs";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "VictoriaMetrics";
    repo = "VictoriaMetrics";
    tag = "v${finalAttrs.version}-victorialogs";
    hash = "sha256-E52hvxazzbz9FcPFZFcRHs2vVg6fJJQ8HsieQovQSi4=";
  };

  vendorHash = null;

  subPackages = [
    "app/victoria-logs"
    "app/vlinsert"
    "app/vlselect"
    "app/vlstorage"
    "app/vlogsgenerator"
    "app/vlogscli"
  ];

  postPatch = ''
    # main module (github.com/VictoriaMetrics/VictoriaMetrics) does not contain package
    # github.com/VictoriaMetrics/VictoriaMetrics/app/vmui/packages/vmui/web
    #
    # This appears to be some kind of test server for development purposes only.
    # rm -f app/vmui/packages/vmui/web/{go.mod,main.go}

    # Increase timeouts in tests to prevent failure on heavily loaded builders
    substituteInPlace lib/storage/storage_test.go \
      --replace-fail "time.After(10 " "time.After(120 " \
      --replace-fail "time.NewTimer(30 " "time.NewTimer(120 " \
      --replace-fail "time.NewTimer(time.Second * 10)" "time.NewTimer(time.Second * 120)" \
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=${finalAttrs.version}"
  ];

  preCheck = ''
    # `lib/querytracer/tracer_test.go` expects `buildinfo.Version` to be unset
    export ldflags=''${ldflags//=${finalAttrs.version}/=}
  '';

  __darwinAllowLocalNetworking = true;

  passthru = {
    tests = {
      inherit (nixosTests)
        victorialogs
        ;
    };
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=(.*)-victorialogs" ];
    };
  };

  meta = {
    homepage = "https://docs.victoriametrics.com/victorialogs/";
    description = "User friendly log database from VictoriaMetrics";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ marie ];
    changelog = "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "victoria-logs";
  };
})
