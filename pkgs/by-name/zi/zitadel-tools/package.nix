{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "zitadel-tools";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "zitadel";
    repo = "zitadel-tools";
    rev = "v${version}";
    hash = "sha256-wtCBRsP0b7qPOQfYgvmgDT0t2zZHocokO5J8yLZcsgQ=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-ql5Qw5Va/wLBKsb9bCmPciuVrgORU8nndRkhjoJBIgs=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    local INSTALL="$out/bin/zitadel-tools"
    installShellCompletion --cmd zitadel-tools \
      --bash <($out/bin/zitadel-tools completion bash) \
      --fish <($out/bin/zitadel-tools completion fish) \
      --zsh <($out/bin/zitadel-tools completion zsh)
  '';

  meta = with lib; {
    description = "Helper tools for zitadel";
    homepage = "https://github.com/zitadel/zitadel-tools";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "zitadel-tools";
  };
}
