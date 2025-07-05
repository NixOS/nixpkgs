{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zizmor";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "zizmorcore";
    repo = "zizmor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zxEF76zpqwLroC5GjSkwIC3+XdXmErvabIEqhVe0zCA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vxDyao9pX/CfS08vFmq3vXtgDIg5NXlEwpzroGW48dA=";

  nativeBuildInputs = lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd zizmor \
      --bash <("$out/bin/zizmor" --completions bash) \
      --zsh <("$out/bin/zizmor" --completions zsh) \
      --fish <("$out/bin/zizmor" --completions fish)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^v([0-9.]+\.[0-9.]+\.[0-9.])+$" ];
  };

  meta = {
    description = "Tool for finding security issues in GitHub Actions setups";
    homepage = "https://docs.zizmor.sh/";
    changelog = "https://github.com/zizmorcore/zizmor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lesuisse ];
    mainProgram = "zizmor";
  };
})
