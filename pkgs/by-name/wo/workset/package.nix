{
  fetchFromGitHub,
  rustPlatform,
  lib,
  versionCheckHook,
  pkg-config,
  nix-update-script,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "workset";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "fossable";
    repo = "workset";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aLSpgxTnyloMbCAIf2Uk9w0niJcJ2XZvcIl+T8Dq40U=";
  };

  cargoHash = "sha256-5bOWtKpC4ZtU5gMvwErd7Xqy+awjp7QlnQIFQ+eHGoA=";

  nativeBuildInputs = [ pkg-config ];

  nativeCheckInputs = [ git ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "workset";
    description = "Manage git repos with working sets";
    homepage = "https://github.com/fossable/workset";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cilki ];
  };
})
