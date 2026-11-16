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
  version = "1.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tombi-toml";
    repo = "tombi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qGa/TP6jq562gny7qq9pLDfwdGdZW1g6of/SPy2t3Lc=";
  };

  # Tests relies on the presence of network
  doCheck = false;
  cargoBuildFlags = [
    "--package"
    "tombi-cli"
  ];
  cargoHash = "sha256-KB+Gr7uG+Zq9Uo/ETfVeBg/hLWNC6mY+ugzA4Dx9Biw=";

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
    maintainers = with lib.maintainers; [
      faukah
      psibi
    ];
    mainProgram = "tombi";
  };
})
