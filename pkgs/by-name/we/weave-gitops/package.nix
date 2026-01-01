{
  lib,
  fetchFromGitHub,
  buildGoModule,
  stdenv,
  installShellFiles,
}:

buildGoModule rec {
  pname = "weave-gitops";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "weave-gitops";
    rev = "v${version}";
    sha256 = "sha256-Gm4DIQK8T+dTwB5swdrD+SjGgy/wFQ/fJYdSqNDSy9c=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/weaveworks/weave-gitops/cmd/gitops/version.Version=${version}"
  ];

  vendorHash = "sha256-RiPBlpEQ69fhVf3B0qHQ+zEtPIet/Y/Jp/HfaTrIssE=";

  subPackages = [ "cmd/gitops" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gitops \
      --bash <($out/bin/gitops completion bash 2>/dev/null) \
      --fish <($out/bin/gitops completion fish 2>/dev/null) \
      --zsh <($out/bin/gitops completion zsh 2>/dev/null)
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://docs.gitops.weave.works";
    description = "Weave Gitops CLI";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    homepage = "https://docs.gitops.weave.works";
    description = "Weave Gitops CLI";
    license = licenses.mpl20;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "gitops";
  };
}
