{
  lib,
  buildGoModule,
  fetchFromGitea,
  installShellFiles,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "tea";
  version = "0.11.1";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "tea";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-bphXaE5qPNzqn+PlzESZadpwbS6KryJEnL7hH/CBoTI=";
  };

  vendorHash = "sha256-Y9YDwfubT+RR1v6BTFD+A8GP2ArQaIIoMJmak+Vcx88=";

  ldflags = [
    "-X code.gitea.io/tea/cmd.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

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
