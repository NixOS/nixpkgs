{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "zitadel-tools";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "zitadel";
    repo = "zitadel-tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0Wr+2zWcFDBsQgNRgbCHKyaLdWlldPNkXKo++yoy0KE=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-oqw0Cj+EdYGjNdg8ZazudU8iQXd5oSVrQ34ae1r7Kl4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    local INSTALL="$out/bin/zitadel-tools"
    installShellCompletion --cmd zitadel-tools \
      --bash <($out/bin/zitadel-tools completion bash) \
      --fish <($out/bin/zitadel-tools completion fish) \
      --zsh <($out/bin/zitadel-tools completion zsh)
  '';

  meta = {
    description = "Helper tools for zitadel";
    homepage = "https://github.com/zitadel/zitadel-tools";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "zitadel-tools";
  };
})
