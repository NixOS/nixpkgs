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
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-x";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dl2uxMo81K2ZEAfZk2OP0FXTY4lKGmzqZe0QQo/YIsA=";
  };

  cargoHash = "sha256-+Bva1uch6fd6gl2MH2ss3S6Ea1QkvgVePhdUVUDuIE8=";

  nativeBuildInputs = [
    installShellFiles
    cargo-c
  ];

  postBuild = ''
    ${rust.envVars.setEnv} cargo cbuild --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
  '';

  postInstall = ''
    ${rust.envVars.setEnv} cargo cinstall --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd yr \
      --bash <($out/bin/yr completion bash) \
      --fish <($out/bin/yr completion fish) \
      --zsh <($out/bin/yr completion zsh)
  '';

  checkFlags = [
    # Seems to be flaky
    "--skip=scanner::blocks::tests::block_scanner_timeout"
  ];

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
