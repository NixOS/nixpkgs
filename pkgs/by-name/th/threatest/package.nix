{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "threatest";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "threatest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ieOfCOgEdhfFJbv3wIfC1/QyTrDkq1k6ypbmcgXOpVE=";
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
