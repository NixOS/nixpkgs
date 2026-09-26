{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "woxi";
  version = "0.3.0";

  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-gw2pudFKAFJ6MXzpqg7p5pHPhmQMTPH6hjlEPK6wr60=";
  };

  cargoHash = "sha256-mNA54ukwF6vsbm3sZnlfTENU/Hl2JAXfcZyDfj7LjY4=";

  # The test suite compares Woxi's output against the proprietary
  # `wolframscript` engine, which is unavailable in the sandbox.
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interpreter for a subset of the Wolfram Language";
    homepage = "https://github.com/ad-si/Woxi";
    changelog = "https://github.com/ad-si/Woxi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    mainProgram = "woxi";
    maintainers = with lib.maintainers; [
      ad-si
      Dietr1ch
    ];
    platforms = lib.platforms.unix;
  };
})
