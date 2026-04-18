{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "threatest";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "threatest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BMx+6InL5FF2MH83C6UJ50CSm0Zd69Fs6uwFnunvmqs=";
  };

  proxyVendor = true;
  vendorHash = "sha256-KfIs4LJHOaUKwc3ML/dMwSEkfRT3QW9Nlfla0KqkEyM=";

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
