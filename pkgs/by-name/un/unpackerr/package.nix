{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "unpackerr";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "Unpackerr";
    repo = "unpackerr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eztw5oRM2XWPg0RbJ1GDR+/7r6/10KXpNGj5ijxZzsE=";
  };

  vendorHash = "sha256-qrBqpsmej/voXLmD9uOd2UJ2EZMEybrIWMFVg4pUcLQ=";

  excludedPackages = [ "init/config" ];

  ldflags = [
    "-s"
    "-X 'golift.io/version.Branch=${finalAttrs.version} [nixpkgs]'"
    "-X golift.io/version.BuildUser=nixpkgs"
    "-X golift.io/version.Version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    tests = { inherit (nixosTests) unpackerr; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Extracts downloads so Radarr, Sonarr, Lidarr or Readarr may import them";
    homepage = "https://unpackerr.zip";
    changelog = "https://github.com/Unpackerr/unpackerr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ connor-grady ];
    mainProgram = "unpackerr";
  };
})
