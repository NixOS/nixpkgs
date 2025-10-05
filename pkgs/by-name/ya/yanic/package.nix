{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "yanic";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "FreifunkBremen";
    repo = "yanic";
    rev = "v${version}";
    hash = "sha256-6jGuqqUr9DJyPYAVBBHc5qtfJIbvjGndT2Y+RSLMzhY=";
  };

  vendorHash = "sha256-TcmkPBHxpmTgXNW8gPkzMpjPGCQu/HrZqAu9jDpPEjo=";

  ldflags = [
    "-X github.com/FreifunkBremen/yanic/cmd.VERSION=${version}"
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd yanic \
      --bash <($out/bin/yanic completion bash) \
      --fish <($out/bin/yanic completion fish) \
      --zsh <($out/bin/yanic completion zsh)
  '';

  meta = with lib; {
    description = "Tool to collect and aggregate respondd data";
    homepage = "https://github.com/FreifunkBremen/yanic";
    changelog = "https://github.com/FreifunkBremen/yanic/releases/tag/${src.rev}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ herbetom ];
    mainProgram = "yanic";
  };
}
