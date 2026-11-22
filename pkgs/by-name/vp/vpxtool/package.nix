{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vpxtool";
  version = "0.40.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "francisdb";
    repo = "vpxtool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q89b206s3suHKGnFG5RyIZusyELhMKV73SIdNr6oEO0=";
  };

  cargoHash = "sha256-p1n9k/1t8xoRgiowMhRDTWFxRboombZ9M2bGpNL9qE8=";

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
