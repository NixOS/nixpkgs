{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  installShellFiles,
  nixosTests,
  testers,
  upterm,
}:

buildGoModule (finalAttrs: {
  pname = "upterm";
  version = "0.41.1";

  src = fetchFromGitHub {
    owner = "owenthereal";
    repo = "upterm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XDD7qC7TBfNUz7QQnQI+p1CddrzUWXR7mokXEcRBr28=";
  };

  vendorHash = "sha256-/or+hvaOm6WLJGBt+49g5QBZLZuXGYQGKbwTudCIq2I=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/owenthereal/upterm/internal/version.Version=${finalAttrs.version}"
  ];

  subPackages = [
    "cmd/upterm"
    "cmd/uptermd"
  ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    installShellFiles
  ];

  postInstall = ''
    # force go to build for build arch rather than host arch during cross-compiling
    CGO_ENABLED=0 GOOS= GOARCH= go run cmd/gendoc/main.go
    installManPage etc/man/man*/*
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for cmd in upterm uptermd; do
      installShellCompletion --cmd $cmd \
        --bash <($out/bin/$cmd completion bash) \
        --fish <($out/bin/$cmd completion fish) \
        --zsh <($out/bin/$cmd completion zsh)
    done
  '';

  doCheck = true;

  passthru.tests = {
    inherit (nixosTests) uptermd;
    version = testers.testVersion {
      package = upterm;
      command = "HOME=$PWD upterm version"; # upterm tries to write to $HOME
      version = "Upterm version ${finalAttrs.version}";
    };
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Secure terminal-session sharing";
    homepage = "https://upterm.dev";
    changelog = "https://github.com/owenthereal/upterm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      hax404
      debtquity
    ];
    mainProgram = "upterm";
  };
})
