{
  lib,
  buildGoModule,
  fetchFromGitea,
  gitMinimal,
  installShellFiles,
  stdenv,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "tea";
  version = "0.15.1";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "tea";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-b0Tzw9feSv/7lp67dzBoNV1l97t/AanUOo910Na6RQo=";
  };

  vendorHash = "sha256-tnA14lDGvEdUnOM1/f4d40PBYY7nXkUOTFzxzvzgJvY=";

  ldflags = [
    "-s"
    "-w"
    "-X gitea.dev/tea/modules/version.Version=${finalAttrs.version}"
    "-X gitea.dev/tea/modules/version.Tags=nixpkgs"
    "-X gitea.dev/tea/modules/version.SDK=1.2.0"
  ];

  nativeBuildInputs = [ installShellFiles ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tea \
      --bash <($out/bin/tea completion bash) \
      --fish <($out/bin/tea completion fish) \
      --zsh <($out/bin/tea completion zsh)

    mkdir $out/share/powershell/ -p
    $out/bin/tea completion pwsh > $out/share/powershell/tea.Completion.ps1

    $out/bin/tea man --out $out/share/man/man1/tea.1
  '';

  meta = {
    description = "Gitea official CLI client";
    homepage = "https://gitea.com/gitea/tea";
    changelog = "https://gitea.com/gitea/tea/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      j4m3s
      techknowlogick
    ];
    mainProgram = "tea";
  };
})
