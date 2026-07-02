{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  installShellFiles,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "upterm";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "owenthereal";
    repo = "upterm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-b52Rny6mYkmfF6Umn2tzlnUhNkENHPFpCzp55OWj92w=";
  };

  vendorHash = "sha256-UkZnLbxn0dPT43ycuevcwMw0dXnX1OPHLh5F1XMHWDI=";

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

  passthru.tests = { inherit (nixosTests) uptermd; };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Secure terminal-session sharing";
    homepage = "https://upterm.dev";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hax404 ];
  };
})
