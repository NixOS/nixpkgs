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
  version = "1.37.2";

  src = fetchFromGitHub {
    owner = "VictoriaMetrics";
    repo = "VictoriaLogs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fm3owEi4JzWMAy/jbL1vt8UY5qwT+gDfunxzQY2bIVk=";
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

  postPatch = ''
    # Allow older go versions
    sed -i go.mod -e 's/^go .*/go ${finalAttrs.passthru.go.version}/'
    sed -i vendor/modules.txt -e 's/## explicit; go .*/## explicit; go ${finalAttrs.passthru.go.version}/'

  '';

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
