{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  rustPlatform,
  buildNpmPackage,
  importNpmLock,
  openapi-generator-cli,
  nixosTests,
}:
rustPlatform.buildRustPackage (
  finalAttrs:
  let
    warpgate-web =
      let
        # use an old version because newer version will generate files that fail to be compiled
        openapi-generator-cli-7p7 = openapi-generator-cli.overrideAttrs (old: {
          version = "7.7.0";
          src = fetchurl {
            url = "mirror://maven/org/openapitools/${old.pname}/7.7.0/${old.jarfilename}";
            sha256 = "sha256-OnVydsMdJJpPBqFGUbH/Hxpc9G4RCnCtzEpqKDT4VWE=";
          };
        });
      in
      buildNpmPackage {
        pname = "${finalAttrs.pname}-web";
        version = finalAttrs.version;

        src = finalAttrs.src;
        sourceRoot = "source/warpgate-web";
        # removed openapi-generator-cli from package.json to eliminate collision with nativeBuildInputs
        npmDeps = importNpmLock {
          package = lib.importJSON ./ui-package.json;
          packageLock = lib.importJSON ./ui-package-lock.json;
        };
        npmConfigHook = importNpmLock.npmConfigHook;

        nativeBuildInputs = [ openapi-generator-cli-7p7 ];

        installPhase = "cp -R dist $out";
      };
  in
  {
    pname = "warpgate";
    version = "0.13.3";

    env.SOURCE_DATE_EPOCH = 0; # rust-embed determinism

    src = fetchFromGitHub {
      owner = "warp-tech";
      repo = "warpgate";
      rev = "v${finalAttrs.version}";
      hash = "sha256-TFQwf7YR5tHQtIa7r4Z0APkdEJVMzWDhkybeBhZSjjE=";
    };

    cargoHash = "sha256-C0MpHOYUKsMqp5eSzJ+clFd0mZDQXeZqKBE9H+T/kXo=";

    buildFeatures = [
      "postgres"
      "mysql"
      "sqlite"
    ];

    preBuild = ''ln -rs "${warpgate-web}" warpgate-web/dist'';

    # skip check, project included tests require python stuff and docker
    doCheck = false;

    passthru.tests = {
      inherit (nixosTests) warpgate;
    };

    meta = {
      description = "Smart SSH, HTTPS, MySQL and Postgres bastion that requires no additional client-side software";
      homepage = "https://warpgate.null.page";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux;
      mainProgram = "warpgate";
      maintainers = with lib.maintainers; [ alemonmk ];
    };
  }
)
