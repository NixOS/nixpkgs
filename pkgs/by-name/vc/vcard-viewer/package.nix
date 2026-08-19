{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vcard-viewer";
  version = "0.1.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "affolter-engineering";
    repo = "vcard-viewer";
    tag = finalAttrs.version;
    hash = "sha256-QJSAp8JZZfg22TYBDfstL5V4e8sAOAp6OEvjCSvGtc0=";
  };

  cargoHash = "sha256-D2XR3cGmj3xZS49sRvKwCRXDAPEAK9MWAciMxfixrTY=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line vCard tool that parses and displays vCards";
    homepage = "https://github.com/affolter-engineering/vcard-viewer";
    changelog = "https://github.com/affolter-engineering/vcard-viewer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "vcard-viewer";
  };
})
