{
  lib,
  stdenv,
  buildGoModule,
  fetchFromCodeberg,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "yanic";
  version = "2.1.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "FreifunkBremen";
    repo = "yanic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vTLPPwyJQTHjrIkOEa4+9cgH3lrXsCd6JWd2EFMDb0M=";
  };

  vendorHash = "sha256-2ebCeLLNfpsk8d89SBsaeTXvpWX1YNzo8bATCPD/Shw=";

  subPackages = [
    "."
    "cmd"
  ];

  ldflags = [
    "-X codeberg.org/FreifunkBremen/yanic/cmd.VERSION=${finalAttrs.version}"
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to collect and aggregate respondd data";
    homepage = "https://freifunkbremen.codeberg.page/yanic";
    changelog = "https://codeberg.org/FreifunkBremen/yanic/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ herbetom ];
    mainProgram = "yanic";
  };
})
