{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typos";
  version = "1.50.0";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "typos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N0f0TzaADWttktDP5IjZ58TE4er2KxiEbcoY8wvzQT8=";
  };

  cargoHash = "sha256-/mzEfJCsXvtjYfKwo4knO26gD8rgLn90YM9G/PS72KI=";

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
