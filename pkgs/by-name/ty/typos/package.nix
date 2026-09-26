{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typos";
  version = "1.50.2";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "typos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4gcTAr2CtUz9GmbfK92IYRwLGrPcWsBq+1sl/etq30s=";
  };

  cargoHash = "sha256-TkNcouBTvwlIBhO4B8CDwuB9qco8iZ57BQKJUiYORqo=";

  passthru.updateScript = nix-update-script { };

  preCheck = ''
    export LC_ALL=C.UTF-8
  '';

  postCheck = ''
    unset LC_ALL
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Source code spell checker";
    mainProgram = "typos";
    homepage = "https://github.com/crate-ci/typos";
    changelog = "https://github.com/crate-ci/typos/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      mgttlinger
      chrjabs
    ];
  };
})
