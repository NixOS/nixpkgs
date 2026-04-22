{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  git,
  openssl,
  docker,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wrkflw";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "bahdotsh";
    repo = "wrkflw";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2k2U90Sqe0AOmOMDfy9CPwlHx6pACZ4dKNO7P5IdRvo=";
  };

  cargoHash = "sha256-fp+JFrIcnWXA9SyyVrjX/0nJdLnbySAN0c1VrTeRmMA=";

  nativeBuildInputs = [
    pkg-config
    git
  ];
  buildInputs = [
    openssl
    docker
  ];

  # Prepare the necessary environment for the tests
  preCheck = ''
    git init -b main
    git add .
    git -c user.name="John Smith" -c user.email=john.smith@example.com commit -m "initial commit"
    export HOME=$(mktemp -d)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  __darwinAllowLocalNetworking = true;
  sandboxProfile = ''
    (allow mach-lookup
      (global-name "com.apple.SystemConfiguration.configd")
      (global-name "com.apple.FSEvents"))
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Validate and execute GitHub Actions workflows locally";
    homepage = "https://github.com/bahdotsh/wrkflw";
    changelog = "https://github.com/bahdotsh/wrkflw/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      da157
      FKouhai
      tebriel
    ];
    mainProgram = "wrkflw";
  };
})
