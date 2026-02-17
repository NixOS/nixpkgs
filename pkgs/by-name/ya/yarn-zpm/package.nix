{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yarn-zpm";
  version = "6.0.0-rc.13";

  src = fetchFromGitHub {
    owner = "yarnpkg";
    repo = "zpm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mfzy2dmnQWD8B3bYhMnqAic7rv4JS6pzuqGKrrCqCY0=";
  };

  cargoHash = "sha256-k5lOVe9Ju6BjHswaN7WrzpHgyuOcHTCOEH+ExzUC5lc=";

  cargoBuildFlags = [ "--package=zpm" ];
  cargoTestFlags = [ "--package=zpm" ];

  # yarn is the Yarn Switch binary (zpm-switch package), yarn-bin is the actual package manager (zpm package)
  # See https://yarn6.netlify.app/getting-started/#:~:text=You%20can%20bypass%20Yarn%20Switch
  postInstall = ''
    mv $out/bin/yarn-bin $out/bin/yarn
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Yarn is an open-source package manager for JavaScript and TypeScript projects";
    homepage = "https://yarn6.netlify.app";
    changelog = "https://github.com/yarnpkg/zpm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    mainProgram = "yarn";
  };
})
