{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vpxtool";
  version = "0.37.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "francisdb";
    repo = "vpxtool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Iil/sOXlPl3zMEYXOqBxA19iqgQvRVb4nMBhTGyDgZk=";
  };

  cargoHash = "sha256-E/bfPZzdRzhOA0QApp445YFtovTC71httYSo6VIZORs=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal based frontend and utilities for Visual Pinball";
    homepage = "https://github.com/francisdb/vpxtool";
    changelog = "https://github.com/francisdb/vpxtool/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nmoya ];
    mainProgram = "vpxtool";
  };
})
