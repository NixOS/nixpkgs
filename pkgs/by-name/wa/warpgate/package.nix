{
  lib,
  replaceVars,
  fetchurl,
  fetchFromGitHub,
  rustPlatform,
  buildNpmPackage,
  openapi-generator-cli,
  nixosTests,
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

      npmDepsHash = "sha256-JW3nibMIETj5PQcaNRS5UVZgguSvGd9Bw8uGD3kb5uM=";

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
    version = "0.23.4";

    src = fetchFromGitHub {
      owner = "warp-tech";
      repo = "warpgate";
      tag = "v${finalAttrs.version}";
      hash = "sha256-/IhnDBQq7Ed5vaGiCHNTcE7Uu9b9VrBN1ipCd2Tai1o=";
    };

    cargoHash = "sha256-PRR+bzvmWcWUVdV1HqDqD08SwvDCvGXMvkIVoFEnaQI=";

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

    passthru.tests = {
      inherit (nixosTests) warpgate;
    };

    meta = {
      description = "Smart SSH, HTTPS, MySQL and Postgres bastion that requires no additional client-side software";
      homepage = "https://warpgate.null.page";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
      mainProgram = "warpgate";
      maintainers = with lib.maintainers; [ alemonmk ];
    };
  }
)
