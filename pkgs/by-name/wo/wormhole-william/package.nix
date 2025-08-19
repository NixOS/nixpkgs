{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "wormhole-william";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "psanford";
    repo = "wormhole-william";
    rev = "v${version}";
    sha256 = "sha256-KGJfz3nd03vcdrIsX8UUfdw96XwyU9PRzwK8O4/I8JQ=";
  };

  vendorHash = "sha256-7KOeG0orp7pLlk9VlPwHW/SWKgRe3/kmT3JXBgOCcTg=";

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    # wormhole_test.go:692: failed to establish connection
    substituteInPlace wormhole/wormhole_test.go \
      --replace "TestWormholeDirectoryTransportSendRecvDirect" \
                "SkipWormholeDirectoryTransportSendRecvDirect"
  '';

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd wormhole-william \
      --bash <($out/bin/wormhole-william shell-completion bash) \
      --fish <($out/bin/wormhole-william shell-completion fish) \
      --zsh <($out/bin/wormhole-william shell-completion zsh)
  '';

  meta = {
    homepage = "https://github.com/psanford/wormhole-william";
    description = "End-to-end encrypted file transfers";
    changelog = "https://github.com/psanford/wormhole-william/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psanford ];
    mainProgram = "wormhole-william";
  };
}
