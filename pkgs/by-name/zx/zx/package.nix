{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,

  esbuild,
  buildGoModule,
}:

let
  esbuild' = esbuild.override {
    buildGoModule =
      args:
      buildGoModule (
        args
        // rec {
          version = "0.25.0";
          src = fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            rev = "v${version}";
            hash = "sha256-L9jm94Epb22hYsU3hoq1lZXb5aFVD4FC4x2qNt0DljA=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        }
      );
  };
in
buildNpmPackage rec {
  pname = "zx";
  version = "8.4.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "zx";
    rev = version;
    hash = "sha256-SzAyj7CrZndV1SD7QBVSqtoXOw95a6CboYkkvXEigV4=";
  };

  npmDepsHash = "sha256-+X9UqfzFGyH4n3gACUBXLA7Bk6M8PfLE68A/TET42Ig=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  ESBUILD_BINARY_PATH = lib.getExe esbuild';

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
