{
  lib,
<<<<<<< HEAD
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
=======
  buildGoModule,
  fetchFromGitHub,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  installShellFiles,
  nixosTests,
}:

<<<<<<< HEAD
buildGoModule (finalAttrs: {
  pname = "upterm";
  version = "0.20.0";
=======
buildGoModule rec {
  pname = "upterm";
  version = "0.15.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "owenthereal";
    repo = "upterm";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-qTw8bYROAAB7FwKCCQamIbWGbqSexXl87DdvSNsFZ/I=";
  };

  vendorHash = "sha256-5OAS7s9A95h5LihXgOwkOXAMylS7g+lqjaI3MKTvlW0=";
=======
    rev = "v${version}";
    hash = "sha256-9h4Poz0hUg5/7CrF0ZzT4KrVaFlhvcorIgZbleMpV6w=";
  };

  vendorHash = "sha256-i92RshW5dsRE88X8bXyrj13va66cc0Yu/btpR0pvoSM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [
    "cmd/upterm"
    "cmd/uptermd"
  ];

<<<<<<< HEAD
  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    installShellFiles
  ];
=======
  nativeBuildInputs = [ installShellFiles ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postInstall = ''
    # force go to build for build arch rather than host arch during cross-compiling
    CGO_ENABLED=0 GOOS= GOARCH= go run cmd/gendoc/main.go
    installManPage etc/man/man*/*
<<<<<<< HEAD
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for cmd in upterm uptermd; do
      installShellCompletion --cmd $cmd \
        --bash <($out/bin/$cmd completion bash) \
        --fish <($out/bin/$cmd completion fish) \
        --zsh <($out/bin/$cmd completion zsh)
    done
=======
    installShellCompletion --bash --name upterm.bash etc/completion/upterm.bash_completion.sh
    installShellCompletion --zsh --name _upterm etc/completion/upterm.zsh_completion
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  doCheck = true;

  passthru.tests = { inherit (nixosTests) uptermd; };

  __darwinAllowLocalNetworking = true;

<<<<<<< HEAD
  meta = {
    description = "Secure terminal-session sharing";
    homepage = "https://upterm.dev";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hax404 ];
  };
})
=======
  meta = with lib; {
    description = "Secure terminal-session sharing";
    homepage = "https://upterm.dev";
    license = licenses.asl20;
    maintainers = with maintainers; [ hax404 ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
