{
  rustPlatform,
  fetchFromGitHub,
  lib,
  stdenv,
  installShellFiles,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (final: {
  pname = "tirith";
  version = "0.4.1";
  src = fetchFromGitHub {
    owner = "sheeki03";
    repo = "tirith";
    tag = "v${final.version}";
    hash = "sha256-WyLcLKQ75UVaE6WtT0CaxfDS4qY/ShO9roMxQJPp5qE=";
  };

  cargoHash = "sha256-MYYAltyAFFt1BSkOwWpMEKw5rzQfduzDG7JcBEzKbOg=";

  cargoBuildFlags = [
    "-p"
    "tirith"
  ];

  doCheck = false;

  nativeBuildInputs = lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    installShellFiles
  ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  __darwinAllowLocalNetworking = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tirith \
      --bash <("$out/bin/tirith" completions bash) \
      --zsh <("$out/bin/tirith" completions zsh) \
      --fish <("$out/bin/tirith" completions fish)
  '';

  meta = {
    description = "Shell security tool that guards against homograph URL attacks, pipe-to-shell exploits, and other command-line threats before they execute";
    homepage = "https://github.com/sheeki03/tirith";
    changelog = "https://github.com/sheeki03/tirith/blob/${final.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ toasteruwu ];
    platforms = lib.platforms.unix;
    mainProgram = "tirith";
  };
})
