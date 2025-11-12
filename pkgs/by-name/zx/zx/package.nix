{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "zx";
  version = "8.8.5";

  src = fetchFromGitHub {
    owner = "google";
    repo = "zx";
    tag = finalAttrs.version;
    hash = "sha256-TB4TDGvrMqJgLGm2E3wGLg/uJv3YmbAuxTuZGerj7vM=";
  };

  npmDepsHash = "sha256-yr4oPr4tTFfl+uUc2RJnVkmzSVHrw2adzWuZ+R2bQaU=";

  npmFlags = [ "--legacy-peer-deps" ];

  dontNpmBuild = true;

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for writing scripts using JavaScript";
    homepage = "https://github.com/google/zx";
    changelog = "https://github.com/google/zx/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jlbribeiro
      f64u
    ];
    mainProgram = "zx";
  };
})
