{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vpxtool";
  version = "0.34.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "francisdb";
    repo = "vpxtool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rO70j+St4T8/ki405VqeGwmP73/prymEw79np7pIuSg=";
  };

  cargoHash = "sha256-PD9yyJ1yos0qywsGj8HapWkneOxG/0TesVATudasjTE=";

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
