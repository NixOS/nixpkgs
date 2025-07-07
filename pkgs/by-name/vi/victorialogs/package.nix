{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  withServer ? true,
  withVlAgent ? false,
}:

buildGoModule (finalAttrs: {
  pname = "VictoriaLogs";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "VictoriaMetrics";
    repo = "VictoriaLogs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KhXB+37uK08dDYXtnaPDS7gP/gBGZ0gqyR0u572QOx8=";
  };

  vendorHash = null;

  subPackages =
    lib.optionals withServer [
      "app/victoria-logs"
      "app/vlinsert"
      "app/vlselect"
      "app/vlstorage"
      "app/vlogsgenerator"
      "app/vlogscli"
    ]
    ++ lib.optionals withVlAgent [ "app/vlagent" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  passthru = {
    tests = {
      inherit (nixosTests)
        victorialogs
        ;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://docs.victoriametrics.com/victorialogs/";
    description = "User friendly log database from VictoriaMetrics";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      marie
      shawn8901
    ];
    changelog = "https://github.com/VictoriaMetrics/VictoriaLogs/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "victoria-logs";
  };
})
