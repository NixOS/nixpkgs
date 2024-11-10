{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "zx";
  version = "8.2.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "zx";
    rev = "0f2be5b053b7649fca84c92cd04310b94e297413";
    hash = "sha256-4shiST6KMWc89AkAv8A5MQJGDWuwyRwOwKHuAVUcbbg=";
  };

  npmDepsHash = "sha256-IYx0g3Fxi4/iuljo8mDlQtTGHhJilDPXYHC2xe6P5fs=";

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
