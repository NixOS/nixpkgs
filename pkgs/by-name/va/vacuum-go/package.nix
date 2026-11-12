{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "vacuum-go";
  version = "0.30.6";

  src = fetchFromGitHub {
    owner = "daveshanley";
    repo = "vacuum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-27ZGWy9lblCAlvodpmgyhHaS2uHP5gpM8SDh44agdZ8=";
  };

  vendorHash = "sha256-0fKjscF77MubYr+AhvWAk8Oh0OQP948vGW8zbwAS1xw=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  tags = [ "html_report_ui" ];

  preBuild = ''
    mkdir -p html-report/ui/build/static/js
    cp ${finalAttrs.passthru.htmlReportUI}/static/js/vacuumReport.js html-report/ui/build/static/js/
    cp ${finalAttrs.passthru.htmlReportUI}/static/js/hydrate.js html-report/ui/build/static/js/
  '';

  subPackages = [ "./vacuum.go" ];

  passthru = {
    # see upstream scripts/build-ui-assets.sh
    htmlReportUI = buildNpmPackage {
      pname = "vacuum-html-report-ui";
      inherit (finalAttrs) version src;

      sourceRoot = "${finalAttrs.src.name}/html-report/ui";

      npmDepsHash = "sha256-DU6kgafGmAi1QTcAbseSl473467YN0E2lXeGYlpUZ68=";

      installPhase = ''
        runHook preInstall
        cp -r build "$out"
        runHook postInstall
      '';
    };

    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "vacuum version";
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "World's fastest OpenAPI & Swagger linter";
    homepage = "https://quobix.com/vacuum";
    changelog = "https://github.com/daveshanley/vacuum/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "vacuum";
    maintainers = with lib.maintainers; [ konradmalik ];
  };
})
