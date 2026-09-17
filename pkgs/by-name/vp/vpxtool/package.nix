{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vpxtool";
  version = "0.34.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "francisdb";
    repo = "vpxtool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RnsoN/i/xvmeQ5tyNdkjn77WKGcVLS/seb3PamTLzVc=";
  };

  cargoHash = "sha256-E+YxfnUdzNaiJlmIWNPX8Sf5m9M2xvrgpmjwWth0aZo=";

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
