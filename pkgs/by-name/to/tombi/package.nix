{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tombi";
  version = "0.6.51";

  src = fetchFromGitHub {
    owner = "tombi-toml";
    repo = "tombi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b4W8A0YciNUgh57AFFchp5x9NqQa4TypnujcfFUWv/0=";
  };

  # Tests relies on the presence of network
  doCheck = false;
  cargoBuildFlags = [ "--package tombi-cli" ];
  cargoHash = "sha256-8wKsayFbTQ2viR0Z9ASpqNwCaWqAZ4TImYJsoxsq3uc=";

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'version = "0.0.0-dev"' 'version = "${finalAttrs.version}"'
  '';

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tombi \
      --bash <($out/bin/tombi completion bash) \
      --fish <($out/bin/tombi completion fish) \
      --zsh <($out/bin/tombi completion zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  meta = {
    description = "TOML Formatter / Linter / Language Server";
    homepage = "https://github.com/tombi-toml/tombi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psibi ];
    mainProgram = "tombi";
  };
})
