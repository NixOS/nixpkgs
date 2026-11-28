{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  versionCheckHook,
  libgit2,
  nix-update-script,
  oniguruma,
  pkg-config,
  ps,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuicr";
  version = "0.30.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "agavra";
    repo = "tuicr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NmQGLpZrwaI0jEz6Nj7y7E5bLfM6cXVS2ASM+p3Iusw=";
  };

  cargoHash = "sha256-bAHBnC0AmlETp262/Wx9INBv9QX7WUw6c3tXQ3K8x5s=";

  buildInputs = [
    libgit2
    oniguruma
  ];

  nativeBuildInputs = [ pkg-config ];

  nativeCheckInputs = [
    gitMinimal
    ps
  ];

  checkFlags = [
    # expects to be run inside the upstream git repository
    "--skip=should_return_no_changes_for_clean_repo"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Review AI-generated diffs like a GitHub pull request, right from your terminal";
    homepage = "https://tuicr.dev";
    changelog = "https://github.com/agavra/tuicr/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "tuicr";
  };
})
