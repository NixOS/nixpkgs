{
  lib,
  buildGoLatestModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:
let
  version = "2.17.4";
in
buildGoLatestModule {
  pname = "wakapi";
  inherit version;

  src = fetchFromGitHub {
    owner = "muety";
    repo = "wakapi";
    tag = version;
    hash = "sha256-pcKHDZH8CvRpKPaLyWPsHx7/U50xEq8JzbnEQG/9uYI=";
  };

  vendorHash = "sha256-bXIbHSclJ61D3u1+nXEIRhzw611uosnnXWqT9boDMP0=";

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
