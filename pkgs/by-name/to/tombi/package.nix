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
<<<<<<< HEAD
  version = "0.7.12";
=======
  version = "0.6.55";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "tombi-toml";
    repo = "tombi";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-UeccD8fsph9y054vGDQMwGEeoaHEY0lPL0/X3QIn97g=";
=======
    hash = "sha256-kJ8F0gAx7ua6FvHZCSY19KOPKiCvlHIiRPwgG1HiiEY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Tests relies on the presence of network
  doCheck = false;
  cargoBuildFlags = [ "--package tombi-cli" ];
<<<<<<< HEAD
  cargoHash = "sha256-Gp8wU0+jIcFYqtFWVXfLmEx28jLcFwtMsGzDbvo/O8s=";
=======
  cargoHash = "sha256-BP0sxpplP3O/YVy2RPEd7ojFQ7a6Gl4valRBL3Twnug=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
