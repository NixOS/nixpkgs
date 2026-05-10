{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typical";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "typical";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gcaOQhEyCiU2kXWZRymGca0Mq+TOBGDR4v/5sFOaDz0=";
  };

  cargoHash = "sha256-cRlxyh8a+lJLc/YkOYYXkCEi8D3KJHlm5a01rhWk3VQ=";

  nativeBuildInputs = [
    installShellFiles
  ];

  preCheck = ''
    export NO_COLOR=true
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd typical \
      --bash <($out/bin/typical shell-completion bash) \
      --fish <($out/bin/typical shell-completion fish) \
      --zsh <($out/bin/typical shell-completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  meta = {
    description = "Data interchange with algebraic data types";
    mainProgram = "typical";
    homepage = "https://github.com/stepchowfun/typical";
    changelog = "https://github.com/stepchowfun/typical/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
