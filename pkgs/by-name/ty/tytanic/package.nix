{
  lib,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tytanic";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "typst-community";
    repo = "tytanic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/yPRJoQ5Lr75eL5+Vc+2E278og/02CYSEuBBgHO1NnU=";
  };

  cargoHash = "sha256-/EAFV1JkOTmVkoYyaGLAk/i8PAB4LLzULIS10E9XZpM=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env = {
    OPENSSL_NO_VENDOR = true; # From the typst package.
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/typst-community/tytanic/releases/tag/v${finalAttrs.version}";
    description = "Test runner for Typst projects";
    homepage = "https://typst-community.github.io/tytanic";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "tt";
    maintainers = with lib.maintainers; [ andrew15-5 ];
    platforms = lib.platforms.all; # Should work on most platforms.
  };
})
