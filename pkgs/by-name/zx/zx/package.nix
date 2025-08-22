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
            version = "0.25.8";
          in
          {
            inherit version;
            src = fetchFromGitHub {
              owner = "evanw";
              repo = "esbuild";
              tag = "v${version}";
              hash = "sha256-eouplmjMm8NRxW6kxrzaLtfKDQOMFSbYBq7bET7oQ5s=";
            };
            vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
          }
        )
      );
  };
in
buildNpmPackage (finalAttrs: {
  pname = "zx";
  version = "8.8.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "zx";
    tag = finalAttrs.version;
    hash = "sha256-qJsHrQPG1Uo6SaoPi1/KnUNj3n/w0qJEqJtSmckjDdw=";
  };

  npmDepsHash = "sha256-KL8qcZGdIetQfS2OISZRh6smthrnLCDPoW8GKczC8iI=";

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
