{
  lib,
  stdenv,
  go,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
  testers,
  updatecli,
}:

buildGoModule rec {
  pname = "updatecli";
<<<<<<< HEAD
  version = "0.111.0";
=======
  version = "0.110.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "updatecli";
    repo = "updatecli";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ohsb8gObY25c5kkUaDWAd2VKfOUQ6/xwjPPyCeqxuRA=";
  };

  vendorHash = "sha256-Io4+4CE+Rb7XD7Q/JSbzXcG7nXXXSNFE8OCCLlqt8Ek=";
=======
    hash = "sha256-PeCvJx582Ndz11CmOwGT0fmqplhOqCT98xhtH0Me818=";
  };

  vendorHash = "sha256-2LiPLFjFxyoypEe1dCzMIQvIN6CfnDr0/EZuGkmA2kM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # tests require network access
  doCheck = false;

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/updatecli/updatecli/pkg/core/version.BuildTime=unknown"
    ''-X "github.com/updatecli/updatecli/pkg/core/version.GoVersion=go version go${lib.getVersion go}"''
    "-X github.com/updatecli/updatecli/pkg/core/version.Version=${version}"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = updatecli;
      command = "updatecli version";
    };
  };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd updatecli \
      --bash <($out/bin/updatecli completion bash) \
      --fish <($out/bin/updatecli completion fish) \
      --zsh <($out/bin/updatecli completion zsh)

    $out/bin/updatecli man > updatecli.1
    installManPage updatecli.1
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Declarative Dependency Management tool";
    longDescription = ''
      Updatecli is a command-line tool used to define and apply update strategies.
    '';
    homepage = "https://www.updatecli.io";
    changelog = "https://github.com/updatecli/updatecli/releases/tag/${src.rev}";
<<<<<<< HEAD
    license = lib.licenses.asl20;
    mainProgram = "updatecli";
    maintainers = with lib.maintainers; [
=======
    license = licenses.asl20;
    mainProgram = "updatecli";
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      croissong
      lpostula
    ];
  };
}
