{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  testers,
  yara-x,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yara-x";
  version = "0.14.0";

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-x";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C8wBGmilouNcNN3HkwvSTWcZY1fe0jVc2TeWDN4w5xA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-afCBuWr12trjEIDvE0qnGFxTXU7LKZCzZB8RqgqperY=";

  buildCAPI = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd yr \
      --bash <($bin/bin/yr completion bash) \
      --fish <($bin/bin/yr completion fish) \
      --zsh <($bin/bin/yr completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = yara-x;
  };

  meta = {
    description = "Tool to do pattern matching for malware research";
    homepage = "https://virustotal.github.io/yara-x/";
    changelog = "https://github.com/VirusTotal/yara-x/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      fab
      lesuisse
    ];
    mainProgram = "yr";
    pkgConfigModules = [ "yara_x_capi" ];
  };
})
