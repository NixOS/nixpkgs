{
  lib,
  stdenv,
  dnsmasq,
  makeWrapper,
  installShellFiles,
  writableTmpDirAsHomeHook,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "virter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "LINBIT";
    repo = "virter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EL6yBIeZx2WN6Svo8j1tL4VID5eQJcj8OtDrlHhUTbw=";
  };

  vendorHash = "sha256-fOs+PKSIyCYzjvHOjqL5r3C4IXNsnOAJy2y3crqchHg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/LINBIT/virter/cmd.version=${finalAttrs.version}"
    "-X github.com/LINBIT/virter/cmd.builddate=builtByNix"
    "-X github.com/LINBIT/virter/cmd.githash=builtByNix"
  ];

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    wrapProgram $out/bin/virter \
      --prefix PATH ":" ${lib.makeBinPath [ dnsmasq ]}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd virter \
      --bash <($out/bin/virter completion bash) \
      --fish <($out/bin/virter completion fish) \
      --zsh <($out/bin/virter completion zsh)
  '';

  # requires network access
  doCheck = false;

  meta = {
    description = "Command line tool for simple creation and cloning of virtual machines based on libvirt";
    homepage = "https://github.com/LINBIT/virter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "virter";
  };
})
