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

      npmDepsHash = "sha256-1zCxKAH2IAKSFdL8Pyd8dJi0i8Y5mgYcWNKVpiQszc0=";

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
    version = "0.17.0";

    src = fetchFromGitHub {
      owner = "warp-tech";
      repo = "warpgate";
      tag = "v${finalAttrs.version}";
      hash = "sha256-nr0z8c0o5u4Rqs9pFUaxnasRHUhwT3qQe5+JNV+LObg=";
    };

    cargoHash = "sha256-pIr5Z7rp+dYOuKYnlsBdya6MqAdL0U2gUhwXvLfmM34=";

    patches = [
      (replaceVars ./hardcode-version.patch { inherit (finalAttrs) version; })
      ./disable-rust-reproducible-build.patch
    ];

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
