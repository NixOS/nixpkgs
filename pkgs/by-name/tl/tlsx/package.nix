{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "tlsx";
  version = "1.4.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "tlsx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-clKmXZxfP5xZZUNFZ+N/Y+cQnhe1wJC+QIlkrJ+L5KY=";
  };

  vendorHash = "sha256-kzzQx5+A/TZ8wBex01nuhJx9gkE2Ef9EOkkqlBEBNzc=";

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  ldflags = [ "-s" ];

  # Tests require network access
  doCheck = false;

  # Version is out-dated upstream
  doInstallCheck = false;

  versionCheckProgramArg = [ "-version" ];

  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TLS grabber focused on TLS based data collection";
    longDescription = ''
      A fast and configurable TLS grabber focused on TLS based data
      collection and analysis.
    '';
    homepage = "https://github.com/projectdiscovery/tlsx";
    changelog = "https://github.com/projectdiscovery/tlsx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "tlsx";
  };
})
