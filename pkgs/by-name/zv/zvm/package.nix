{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "zvm";
  version = "0.9.4";

  __structuredAttrs = true;

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "tristanisham";
    repo = "zvm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cv9O9fUiYNYvSqH8RXcBXEhErK9lObqzHK9QBERJV7Y=";
  };

  vendorHash = "sha256-YIhYRq55WWcXz50DDRgMzzXNKbA16vlfKqlrgziD1qA=";

  ldflags = [
    "-s"
    "-X 'main.BuildUpgradeMessage=This package is maintained in Nixpkgs'"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage man/*.1
  '';

  doInstallCheck = true;
  versionCheckKeepEnvironment = [ "HOME" ];
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.zvm.app/";
    downloadPage = "https://github.com/tristanisham/zvm";
    changelog = "https://github.com/tristanisham/zvm/releases/tag/v${finalAttrs.version}";
    description = "Tool to manage and use different Zig versions";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = lib.platforms.unix;
    mainProgram = "zvm";
  };
})
