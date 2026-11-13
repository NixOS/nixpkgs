{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  oniguruma,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xq";
  version = "0.5.0";

  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-kgOwTQ+t5dhhb+MrilBZ5E7Ge3U6dllUpJ2I1fCX+jc=";
  };

  cargoHash = "sha256-xQ650Yx+lk+UKIHrad48eWUB/TUHeutL6tSrYwV0Eeg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ oniguruma ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Pure rust implementation of jq";
    homepage = "https://github.com/MiSawa/xq";
    changelog = "https://github.com/MiSawa/xq/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "xq";
  };
})
