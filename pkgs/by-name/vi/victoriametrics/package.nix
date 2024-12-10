{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "VictoriaMetrics";
  version = "1.101.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Jjz/CbVCvc9NFbvzYTFthG8cov4pYpc6y1A1Kmd3Mjg=";
  };

  vendorHash = null;

  subPackages = [
    "app/victoria-logs"
    "app/victoria-metrics"
    "app/vlinsert"
    "app/vlselect"
    "app/vlstorage"
    "app/vmagent"
    "app/vmalert-tool"
    "app/vmalert"
    "app/vmauth"
    "app/vmctl"
    "app/vminsert"
    "app/vmselect"
    "app/vmstorage"
    "app/vmbackup"
    "app/vmrestore"
    "app/vmui"
  ];

  postPatch = ''
    # main module (github.com/VictoriaMetrics/VictoriaMetrics) does not contain package
    # github.com/VictoriaMetrics/VictoriaMetrics/app/vmui/packages/vmui/web
    #
    # This appears to be some kind of test server for development purposes only.
    rm -f app/vmui/packages/vmui/web/{go.mod,main.go}

    # Increase timeouts in tests to prevent failure on heavily loaded builders
    substituteInPlace lib/storage/storage_test.go \
      --replace "time.After(10 " "time.After(120 " \
      --replace "time.NewTimer(30 " "time.NewTimer(120 " \
      --replace "time.NewTimer(time.Second * 10)" "time.NewTimer(time.Second * 120)" \
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=${version}"
  ];

  preCheck = ''
    # `lib/querytracer/tracer_test.go` expects `buildinfo.Version` to be unset
    export ldflags=''${ldflags//=${version}/=}
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests = { inherit (nixosTests) victoriametrics; };

  meta = with lib; {
    homepage = "https://victoriametrics.com/";
    description = "fast, cost-effective and scalable time series database, long-term remote storage for Prometheus";
    license = licenses.asl20;
    maintainers = with maintainers; [
      yorickvp
      ivan
    ];
    changelog = "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/tag/v${version}";
    mainProgram = "victoria-metrics";
  };
}
