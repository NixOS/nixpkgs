{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "threatest";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "threatest";
    tag = "v${version}";
    hash = "sha256-rVRBrf/RTcHvKOLHNASzvij3fV+uQEuIVKb07CZ/cT0=";
  };

  proxyVendor = true;
  vendorHash = "sha256-EvVazz51sW8z+8XfZB0Xo42KuUT6Q9n2Y/0HvlF1bV4=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd threatest \
      --bash <($out/bin/threatest completion bash) \
      --fish <($out/bin/threatest completion fish) \
      --zsh <($out/bin/threatest completion zsh)
  '';

  meta = {
    description = "Framework for end-to-end testing threat detection rules";
    mainProgram = "threatest";
    homepage = "https://github.com/DataDog/threatest";
    changelog = "https://github.com/DataDog/threatest/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
