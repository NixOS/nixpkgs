{
  lib,
  buildGoModule,
  fetchFromGitea,
  installShellFiles,
}:

buildGoModule rec {
  pname = "tea";
  version = "0.10.1";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "tea";
    rev = "v${version}";
    sha256 = "sha256-Dhb3y13sxkyE+2BjNj7YcsjiIPgznIVyuzWs0F8LNfU=";
  };

  vendorHash = "sha256-mKCsBPBWs3+61em53cEB0shTLXgUg4TivJRogy1tYXw=";

  meta = with lib; {
    description = "Gitea official CLI client";
    homepage = "https://gitea.com/gitea/tea";
    license = licenses.mit;
    maintainers = with maintainers; [
      j4m3s
      techknowlogick
    ];
    mainProgram = "tea";
  };

  ldflags = [
    "-X code.gitea.io/tea/cmd.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd tea \
      --bash <($out/bin/tea completion bash) \
      --fish <($out/bin/tea completion fish) \
      --zsh <($out/bin/tea completion zsh)

    mkdir $out/share/powershell/ -p
    $out/bin/tea completion pwsh > $out/share/powershell/tea.Completion.ps1
  '';
}
