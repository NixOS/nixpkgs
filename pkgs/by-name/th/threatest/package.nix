{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "threatest";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "threatest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NYvy+Q9vNFEzqBkX77aF8MMBl8pVQRldyxEiWSOhs1U=";
  };

  proxyVendor = true;
  vendorHash = "sha256-U848PVujiKVyJGtNIvhFlh1lETNB4746UqwIdGCLRpk=";

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
    changelog = "https://github.com/DataDog/threatest/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
