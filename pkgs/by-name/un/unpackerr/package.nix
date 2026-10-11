{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "unpackerr";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "Unpackerr";
    repo = "unpackerr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-npq0CXsaWaFa6RazQXRKVaqTyK87VhzaF/hd/d952Po=";
  };

  vendorHash = "sha256-v0ml1dTIhf79mhlyTrPNhIfg1Yhao27eP0pnI95OvaU=";

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
