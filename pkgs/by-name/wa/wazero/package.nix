{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  wazero,
}:

buildGoModule (finalAttrs: {
  pname = "wazero";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "tetratelabs";
    repo = "wazero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wq6fj6NDKaJbd+8lhrC5tH9lyUL/2Rc/T4Y39LYADsk=";
  };

  vendorHash = "sha256-jsMZWzuOMt9OAA39jr4or9Ljt2sRg7Mw/FScjQ+sulU=";

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
