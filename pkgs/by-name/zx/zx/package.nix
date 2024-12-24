{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "zx";
  version = "8.2.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "zx";
    rev = version;
    hash = "sha256-7VJ29oB5/518KNafdhELekUGCXW8+KunLnOmn1WpGEc=";
  };

  npmDepsHash = "sha256-SDHorWbiN4x7m+2GcT15M4d4SU3jpbVU0iILnINv3UE=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for writing scripts using JavaScript";
    homepage = "https://github.com/google/zx";
    changelog = "https://github.com/google/zx/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jlbribeiro ];
    mainProgram = "zx";
  };
}
