{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "urna";
  version = "0.5.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hoffresearch";
    repo = "urna";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UGUtyhrRSwjAvQt+0Y3LjYzrQx7aPUgt9vYulsDoQMs=";
  };

  cargoHash = "sha256-026wYjJ0+mskY21h2T30zQGDJ29EG3Q7pqKFJEyOg5s=";

  cargoBuildFlags = [
    "-p"
    "urna"
  ];
  cargoTestFlags = [
    "-p"
    "urna"
  ];

  # build.rs names the binary a release of this version, so `urna setup`
  # fetches that release's embedder payload.
  env.URNA_RELEASE_TAG = "v${finalAttrs.version}";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Offline-first vector database in one file, with citations you can verify";
    homepage = "https://urna.dev";
    changelog = "https://github.com/hoffresearch/urna/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ brennercruvinel ];
    mainProgram = "urna";
    platforms = lib.platforms.unix;
  };
})
