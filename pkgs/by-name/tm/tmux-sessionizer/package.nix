{
  fetchFromGitHub,
  generateShellCompletions,
  lib,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  git,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tmux-sessionizer";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "jrmoulton";
    repo = "tmux-sessionizer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-u2PfLFwqO+VFPWeFumrAJWZjK9JMZF/v0pB0uJ8jfq8=";
  };

  cargoHash = "sha256-YVR1m1cosymAKgcsgxSA/iIIF+AJfA92Ibapw0AMfoE=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  doInstallCheck = true;

  nativeBuildInputs = [
    pkg-config
    generateShellCompletions
  ];

  nativeCheckInputs = [
    git
  ];

  postInstall = ''
    generateShellCompletions --env COMPLETE={shell}
  '';

  meta = {
    description = "Fastest way to manage projects as tmux sessions";
    homepage = "https://github.com/jrmoulton/tmux-sessionizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      vinnymeller
      mrcjkb
    ];
    mainProgram = "tms";
  };
})
