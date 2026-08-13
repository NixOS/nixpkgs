{
  lib,
  replaceVars,
  fetchFromGitHub,
  rustPlatform,
  buildNpmPackage,
  openapi-generator-cli,
  nixosTests,
  nix-update-script,
}:
rustPlatform.buildRustPackage (
  finalAttrs:
  let
    warpgate-web = buildNpmPackage {
      pname = "${finalAttrs.pname}-web";
      version = finalAttrs.version;

      src = finalAttrs.src;
      sourceRoot = "${finalAttrs.src.name}/warpgate-web";

      patches = [ ./web-ui-package-json.patch ];

      npmDepsHash = "sha256-McQI5EmTfrbdcWnYRsoRHjhZphrZVaV/fN9i9MX8XF0=";

      nativeBuildInputs = [ openapi-generator-cli ];

      preBuild = "rm node_modules/.bin/openapi-generator-cli";

      installPhase = ''
        runHook preInstall
        cp -R dist $out
        runHook postInstall
      '';
    };
  in
  {
    pname = "warpgate";
    version = "0.26.1";

    src = fetchFromGitHub {
      owner = "warp-tech";
      repo = "warpgate";
      tag = "v${finalAttrs.version}";
      hash = "sha256-1Dg7bzhBQNe+u90Tw+kcmVaxV5IK0/t505HZr18qP5I=";
    };

    cargoHash = "sha256-A5rRLrqlAZV/3ID8F+wUO8OP3Ocivg7vYrNDiMqRKik=";

    patches = [
      (replaceVars ./hardcode-version.patch { inherit (finalAttrs) version; })
      ./remove-nightly-rustflags.patch
    ];

    env.RUSTFLAGS = "--cfg tokio_unstable";

    buildFeatures = [
      "postgres"
      "mysql"
      "sqlite"
    ];

    preBuild = ''
      rm -r .cargo/
      ln -rs "${warpgate-web}" warpgate-web/dist
    '';

    # skip check, project included tests require python stuff and docker
    doCheck = false;

    passthru = {
      inherit warpgate-web;
      tests = {
        inherit (nixosTests) warpgate;
      };
      updateScript = nix-update-script {
        extraArgs = [ "--subpackage=warpgate-web" ];
      };
    };

    meta = {
      description = "Smart SSH, HTTPS, MySQL and Postgres bastion that requires no additional client-side software";
      homepage = "https://warpgate.null.page";
      changelog = "https://github.com/warp-tech/warpgate/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
      mainProgram = "warpgate";
      maintainers = with lib.maintainers; [ alemonmk ];
    };
  }
)
