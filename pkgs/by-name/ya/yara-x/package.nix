{
  lib,
  buildPackages,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  cargo-c,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yara-x";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-x";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UE5x9w9I4l9OqRVv6klveEvIap+El6vea6OsnnOJHus=";
  };

  cargoHash = "sha256-rQ8uBgsJ86K0Qc3uTiFDPmcRU+dF5gu0b5pzMcGAAVU=";

  CARGO_PROFILE_RELEASE_LTO = "fat";
  CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "1";

  nativeBuildInputs = [
    installShellFiles
    cargo-c
  ];

  postBuild = ''
    ${buildPackages.rust.envVars.setEnv} cargo cbuild --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
  '';

  postInstall = ''
    ${buildPackages.rust.envVars.setEnv} cargo cinstall --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
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
  checkType = "debug";

  nativeCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

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
