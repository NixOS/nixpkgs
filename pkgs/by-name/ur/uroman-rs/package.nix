{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uroman-rs";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "fulm-o";
    repo = "uroman-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-22ddG7cCWApSjnndWJz5cUSbMOH6q+5J2IrLkH/XLM4=";
  };

  cargoHash = "sha256-+WjWWFm198hI8nwLNGzEotXuIm62cbwVHBiH347SzRs=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust reimplementation of uroman, a universal romanizer";
    changelog = "https://github.com/fulm-o/uroman-rs/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/fulm-o/uroman-rs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "uroman-rs";
  };
})
