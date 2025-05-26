{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "typescript";
  version = "5.8.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "TypeScript";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fOA5IblxUd+C9ST3oI8IUmTTRL3exC63MPqW5hoWN0M=";
  };

  patches = [
    ./disable-dprint-dstBundler.patch
  ];

  npmDepsHash = "sha256-ytdkxIjAd3UsU90o9IFZa5lGEv39zblBmgTTseVRGKQ=";

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
