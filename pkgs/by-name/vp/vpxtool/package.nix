{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vpxtool";
  version = "0.33.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "francisdb";
    repo = "vpxtool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cgFylbxPEMhynuFH0sfyq0IvSA18K2s/Yn43Z1NbjLQ=";
  };

  cargoHash = "sha256-xsVtNxNQy76KdoZQpfd+h+RvJRLRAQq2gzU+WUiVya4=";

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
