{
  lib,
  buildGoModule,
  fetchFromGitea,
  installShellFiles,
  stdenv,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "tea";
  version = "0.13.0";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "tea";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fycLPF7JBkc9Cjw9mU4cikP9dJzXLa4WAkbZ/+aG6Yw=";
  };

  vendorHash = "sha256-tPlpNfBTcfBJGI0PFD2B1J1nH3wQwJ8uqGcje7wzKTo=";

  ldflags = [
    "-s"
    "-w"
    "-X code.gitea.io/tea/modules/version.Version=${finalAttrs.version}"
    "-X code.gitea.io/tea/modules/version.Tags=nixpkgs"
    "-X code.gitea.io/tea/modules/version.SDK=0.23.2"
  ];

  checkFlags = [
    # requires a git repository
    "-skip=TestRepoFromPath_Worktree"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      j4m3s
      techknowlogick
    ];
    mainProgram = "tea";
  };
})
