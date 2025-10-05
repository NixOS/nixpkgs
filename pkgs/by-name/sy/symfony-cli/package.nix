{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  testers,
  symfony-cli,
  nssTools,
  makeBinaryWrapper,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "symfony-cli";
  version = "5.14.2";
  vendorHash = "sha256-SGD8jFRvdJ5GOeQiW3Whe6EnybQ60wOsC/OureOCn7k=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qgCuerKn7R4bn3YgzpMprIUDfn2SJdIiXC+9avnzDm4=";
    leaveDotGit = true;
    postFetch = ''
      git --git-dir $out/.git log -1 --pretty=%cd --date=format:'%Y-%m-%dT%H:%M:%SZ' > $out/SOURCE_DATE
      rm -rf $out/.git
    '';
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.channel=stable"
  ];

  preBuild = ''
    ldflags+=" -X main.buildDate=$(cat SOURCE_DATE)"
  '';

  buildInputs = [ makeBinaryWrapper ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mkdir $out/libexec
    mv $out/bin/symfony-cli $out/libexec/symfony

    makeBinaryWrapper $out/libexec/symfony $out/bin/symfony \
      --prefix PATH : ${lib.makeBinPath [ nssTools ]}

    installShellCompletion --cmd symfony \
      --bash <($out/bin/symfony completion bash) \
      --fish <($out/bin/symfony completion fish) \
      --zsh <($out/bin/symfony completion zsh)
  '';

  # Tests require network access
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit (finalAttrs) version;
      package = symfony-cli;
      command = "symfony version --no-ansi";
    };
  };

  meta = {
    changelog = "https://github.com/symfony-cli/symfony-cli/releases/tag/v${finalAttrs.version}";
    description = "Symfony CLI";
    homepage = "https://github.com/symfony-cli/symfony-cli";
    license = lib.licenses.agpl3Plus;
    mainProgram = "symfony";
    maintainers = with lib.maintainers; [ patka ];
  };
})
