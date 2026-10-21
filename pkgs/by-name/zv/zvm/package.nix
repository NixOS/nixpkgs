{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "zvm";
  version = "0.9.1";

  __structuredAttrs = true;

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "tristanisham";
    repo = "zvm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J6LDlXkTAdHvtQZimVJ3EPgAzSCvSnVSy+eZe3OwhPg=";
  };

  vendorHash = "sha256-ouRaZ/mrB84e0T2aGJwYPsLoB3a1/kk7WS5rlKBfImU=";

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
