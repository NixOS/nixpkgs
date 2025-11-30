{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  withServer ? true,
  withVtInsert ? false,
  withVtSelect ? false,
  withVtStorage ? false,
  withVtGen ? false,
}:

buildGoModule (finalAttrs: {
  pname = "VictoriaTraces";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "VictoriaMetrics";
    repo = "VictoriaTraces";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RvP3hLM8SoDN91PATTI5RTKwnJsomBtWIakRlBprEPA=";
  };

  postPatch = ''
    substituteInPlace go.mod \
      --replace-fail "go 1.25.4" "go 1.25.3"
    substituteInPlace vendor/modules.txt \
      --replace-fail "go 1.25.4" "go 1.25.3"
  '';

  vendorHash = null;

  subPackages =
    lib.optionals withServer [ "app/victoria-traces" ]
    ++ lib.optionals withVtInsert [ "app/vtinsert" ]
    ++ lib.optionals withVtSelect [ "app/vtselect" ]
    ++ lib.optionals withVtStorage [ "app/vtstorage" ]
    ++ lib.optionals withVtGen [ "app/vtgen" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/VictoriaMetrics/VictoriaTraces/lib/buildinfo.Version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  passthru = {
    tests = {
      inherit (nixosTests) victoriatraces;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://docs.victoriametrics.com/victoriatraces/";
    description = "Fast open-source observability solution for distributed traces";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      cmacrae
      ma27
    ];
    changelog = "https://github.com/VictoriaMetrics/VictoriaTraces/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "victoria-traces";
  };
})
