{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  wazero,
}:

buildGoModule (finalAttrs: {
  pname = "wazero";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "tetratelabs";
    repo = "wazero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yxnHLc0PFxh8NRBgK2hvhKaxRM1w3IZ9TnfJM0+uadg=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/wazero"
  ];

  ldflags = [
    "-s"
    "-X=github.com/tetratelabs/wazero/internal/version.version=${finalAttrs.version}"
  ];

  checkFlags = [
    # fails when version is specified
    "-skip=TestCompile|TestRun"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = wazero;
      command = "wazero version";
    };
  };

  meta = {
    description = "Zero dependency WebAssembly runtime for Go developers";
    homepage = "https://github.com/tetratelabs/wazero";
    maintainers = with lib.maintainers; [ liberodark ];
    changelog = "https://github.com/tetratelabs/wazero/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "wazero";
  };
})
