{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "wormhole-william";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "psanford";
    repo = "wormhole-william";
    rev = "v${version}";
    sha256 = "sha256-KLj9ZeLcIOWA4VeuxfoOr99kUCDb7OARX/h9DSG1WHw=";
  };

  vendorHash = "sha256-oJz7HgtjuP4ooXdpofIKaDndGg4WqVZgbT8Yb1AyaMs=";

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

  meta = with lib; {
    homepage = "https://github.com/psanford/wormhole-william";
    description = "End-to-end encrypted file transfers";
    changelog = "https://github.com/psanford/wormhole-william/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ psanford ];
    mainProgram = "wormhole-william";
  };
}
