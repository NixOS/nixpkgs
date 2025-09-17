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
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-x";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LpdpdzUof+Buz5QQcWUr23AsSyfvUQYPp7RhHWXRb+I=";
  };

  cargoHash = "sha256-IO8ER92vWO3Q9MntaGwdhEFgy9G35Q3LOG5GU5rJpQY=";

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
