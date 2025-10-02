{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "typescript";
  version = "5.9.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "TypeScript";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w37DtnNRs0OH4HRu/sb/h1US9am4aQ0nTkJnjKu457U=";
  };

  patches = [
    ./disable-dprint-dstBundler.patch
  ];

  npmDepsHash = "sha256-6mgCLPy73xblP8ltikrKGHFmvQJncLetQWx32HqQ43U=";

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
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "tsc";
  };
})
