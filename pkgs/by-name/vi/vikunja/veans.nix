{
  meta,
  src,
  version,

  lib,
  buildGoModule,
  installShellFiles,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "veans";
  inherit src version;

  __structuredAttrs = true;

  modRoot = "veans";

  vendorHash = "sha256-4Ayug+r7sWL/JZI8fGCyDZ1SaTwCvSWrQpqv7uYCHhc=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-X main.version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd veans \
      --bash <($out/bin/veans completion bash) \
      --zsh <($out/bin/veans completion zsh) \
      --fish <($out/bin/veans completion fish)
  '';

  # needs a running vikunja instance
  doCheck = false;

  meta = meta // {
    description = "A beans-shaped CLI for Vikunja";
    homepage = "https://vikunja.io/docs/veans/";
    mainProgram = "veans";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
