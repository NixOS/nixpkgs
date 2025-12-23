{
  lib,
  buildNpmPackage,
  buildGoModule,
  fetchFromGitHub,
  esbuild,
  versionCheckHook,
  nix-update-script,
}:

let
  esbuild' = esbuild.override {
    buildGoModule =
      args:
      buildGoModule (
        args
        // (
          let
            version = "0.25.10";
          in
          {
            inherit version;
            src = fetchFromGitHub {
              owner = "evanw";
              repo = "esbuild";
              tag = "v${version}";
              hash = "sha256-EkQOIHqVrULig7s3w4nI8/yVIz2NZA5DCrMof0HHvHM=";
            };
            vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
          }
        )
      );
  };
in
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

  makeCacheWritable = true;

  npmFlags = [ "--legacy-peer-deps" ];

  env.ESBUILD_BINARY_PATH = lib.getExe esbuild';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for writing scripts using JavaScript";
    homepage = "https://github.com/google/zx";
    changelog = "https://github.com/google/zx/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jlbribeiro ];
    mainProgram = "zx";
  };
})
