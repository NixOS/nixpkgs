{
  fetchFromGitHub,
  rustPlatform,
  lib,
  versionCheckHook,
  pkg-config,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "workset";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "fossable";
    repo = "workset";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QPptJEeeyylSyC6RA1yRSPF7M81AGop/NYHJsTHFwkw=";
  };

  cargoHash = "sha256-bPpl68bCJZE+xsmiT8uOpA//++rZRZO09rS7AepwzCw=";

  nativeBuildInputs = [ pkg-config ];

  doCheck = false;

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
