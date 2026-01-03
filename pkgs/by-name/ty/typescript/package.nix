{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "typescript";
  version = "5.9.3";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "TypeScript";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OVsvlHtYZhoCtTxdZO6mhVPpIICWEt1Q92Jqrf95jyM=";
  };

  patches = [
    ./disable-dprint-dstBundler.patch
  ];

  npmDepsHash = "sha256-4ft5168ru+aGPvZAxASQ4wkjtfNG2e0sNhJTedbiKQA=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/tsc";
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex=^v([\\d.]+)$"
      ];
    };
  };

  meta = {
    description = "Superset of JavaScript that compiles to clean JavaScript output";
    homepage = "https://www.typescriptlang.org/";
    changelog = "https://github.com/microsoft/TypeScript/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "tsc";
  };
})
