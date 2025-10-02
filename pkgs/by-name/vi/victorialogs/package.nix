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
  version = "1.35.0";

  src = fetchFromGitHub {
    owner = "VictoriaMetrics";
    repo = "VictoriaLogs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9g23rtLi/tHIXpfZSHgaIHIGHwQ0eYW5kLtMHqrIlMk=";
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
    substituteInPlace go.mod \
      --replace-fail "go 1.25.1" "go ${finalAttrs.passthru.go.version}"

    substituteInPlace vendor/modules.txt \
      --replace-fail "go 1.25.0" "go ${finalAttrs.passthru.go.version}"
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
