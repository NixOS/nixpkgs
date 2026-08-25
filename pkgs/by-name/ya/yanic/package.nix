{
  lib,
  stdenv,
  buildGoModule,
  fetchFromCodeberg,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "yanic";
  version = "1.8.3";

  src = fetchFromCodeberg {
    owner = "FreifunkBremen";
    repo = "yanic";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6jGuqqUr9DJyPYAVBBHc5qtfJIbvjGndT2Y+RSLMzhY=";
  };

  vendorHash = "sha256-TcmkPBHxpmTgXNW8gPkzMpjPGCQu/HrZqAu9jDpPEjo=";

  ldflags = [
    "-X github.com/FreifunkBremen/yanic/cmd.VERSION=${finalAttrs.version}"
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

  meta = {
    description = "Tool to collect and aggregate respondd data";
    homepage = "https://freifunkbremen.codeberg.page/yanic";
    changelog = "https://codeberg.org/FreifunkBremen/yanic/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ herbetom ];
    mainProgram = "yanic";
  };
})
