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
        // rec {
          version = "0.25.3";
          src = fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            tag = "v${version}";
            hash = "sha256-YYwvz6TCLAtVHsmXLGC+L/CQVAy5qSFU6JS1o5O5Zkg=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        }
      );
  };
in
buildNpmPackage (finalAttrs: {
  pname = "zx";
  version = "8.5.4";

  src = fetchFromGitHub {
    owner = "google";
    repo = "zx";
    tag = finalAttrs.version;
    hash = "sha256-328I8SgBIeTCNFH3Ahm9Zb1OCxwGuhWE/iWmDHElbsA=";
  };

  npmDepsHash = "sha256-R0pCoITmLQBj0T1iIXXN4clpEKDn9wkG5Ke0AedgnlQ=";

  env.ESBUILD_BINARY_PATH = lib.getExe esbuild';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

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
