{
  lib,
  buildGoLatestModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:
let
  version = "2.17.5";
in
buildGoLatestModule {
  pname = "wakapi";
  inherit version;

  src = fetchFromGitHub {
    owner = "muety";
    repo = "wakapi";
    tag = version;
    hash = "sha256-CQliu0fPg1k28sL6lhgoXh1GEVM3dBXl6rN0yvHpA2U=";
  };

  vendorHash = "sha256-kA+XeHU7XalQ2xnUfaZcvRAwHDF1hSPUGNXQ7e9y31M=";

  # Not a go module required by the project, contains development utilities
  excludedPackages = [ "scripts" ];

  # Fix up reported version
  postPatch = "echo ${version} > version.txt";

  ldflags = [
    "-s"
    "-w"
  ];

  # <https://github.com/muety/wakapi/blob/8c9442b348e4280b388e1073d805058a951ae78e/.github/workflows/release.yml#L60>
  env.GOEXPERIMENT = "greenteagc,jsonv2";

  checkFlags =
    let
      skippedTests = [
        # Skip tests that require network access
        "TestLoginHandlerTestSuite"
        "TestLoadOidcProviders"
        "TestUser_MinDataAge"
        "TestPublicNetUrl"
        "TestConfigTestSuite"
        "TestWakatimeRelayMiddlewareTestSuite"
        "TestServeHTTP_SkipNonPost"
        "TestWakatimeUtils"
        "TestWakatimeImporterTestSuite/TestCheckUrl"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru = {
    nixos = nixosTests.wakapi;
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://wakapi.dev/";
    changelog = "https://github.com/muety/wakapi/releases/tag/${version}";
    description = "Minimalist self-hosted WakaTime-compatible backend for coding statistics";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      t4ccer
      isabelroses
    ];
    mainProgram = "wakapi";
  };
}
