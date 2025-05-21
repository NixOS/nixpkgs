{
  lib,
  rust,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  cargo-c,
  testers,
  yara-x,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yara-x";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-x";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C8wBGmilouNcNN3HkwvSTWcZY1fe0jVc2TeWDN4w5xA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-afCBuWr12trjEIDvE0qnGFxTXU7LKZCzZB8RqgqperY=";

  nativeBuildInputs = [
    installShellFiles
    cargo-c
  ];

  postBuild = ''
    ${rust.envVars.setEnv} cargo cbuild --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
  '';

  postInstall =
    ''
      ${rust.envVars.setEnv} cargo cinstall --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd yr \
        --bash <($out/bin/yr completion bash) \
        --fish <($out/bin/yr completion fish) \
        --zsh <($out/bin/yr completion zsh)
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
  };
})
