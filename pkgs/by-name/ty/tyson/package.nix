{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "tyson";
  version = "0.1.1-unstable-2024-04-10";

  src = fetchFromGitHub {
    owner = "jetpack-io";
    repo = "tyson";
    rev = "d6b38819db9b260928b29f4d39bf4c72841c6a01";
    hash = "sha256-NoQJBEedV3NDNQ4PVvvjjsO7N+rq40LWKp962P+naEY=";
  };

  vendorHash = "sha256-kJIfKgVaHuCYvvTZXyuZ/Hg8z1BlW4oW6+5s1inFizg=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tyson \
      --bash <($out/bin/tyson completion bash) \
      --fish <($out/bin/tyson completion fish) \
      --zsh <($out/bin/tyson completion zsh)
  '';

  meta = with lib; {
    description = "TypeScript as a configuration language";
    mainProgram = "tyson";
    homepage = "https://github.com/jetify-com/tyson";
    changelog = "https://github.com/jetify-com/tyson/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
