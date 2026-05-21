{
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  testers,
  twitch-cli,
}:

buildGoModule (finalAttrs: {
  pname = "twitch-cli";
  version = "1.1.25";

  src = fetchFromGitHub {
    owner = "twitchdev";
    repo = "twitch-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+6/o2vhj1iaT0hkyQRedn7ga1dhNZOupX4lOadnTDU0=";
  };

  patches = [
    ./application-name.patch
  ];

  vendorHash = "sha256-LPpUnielSeGE0k68z+M565IqXQUIkAh5xloOqcbfh20=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.buildVersion=${finalAttrs.version}"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/twitch-cli completion bash > twitch-cli.bash
    $out/bin/twitch-cli completion fish > twitch-cli.fish
    $out/bin/twitch-cli completion zsh > _twitch-cli
    installShellCompletion --cmd twitch-cli \
      --bash twitch-cli.bash \
      --fish twitch-cli.fish \
      --zsh _twitch-cli
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests.version = testers.testVersion {
    package = twitch-cli;
    command = "HOME=$(mktemp -d) twitch-cli version";
    version = "twitch-cli/${finalAttrs.version}";
  };

  meta = {
    description = "Official Twitch CLI to make developing on Twitch easier";
    mainProgram = "twitch-cli";
    homepage = "https://github.com/twitchdev/twitch-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benediktbroich ];
  };
})
