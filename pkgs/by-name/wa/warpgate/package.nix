{
  lib,
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
    warpgate-web =
      let
        # use an old version because newer version will generate files that fail to be compiled
        openapi-generator-cli' = openapi-generator-cli.overrideAttrs (old: {
          version = "7.12.0";
          src = fetchurl {
            url = "mirror://maven/org/openapitools/openapi-generator-cli/7.12.0/${old.jarfilename}";
            sha256 = "sha256-M+ffp6HwTVhAXuEq4Z4sb8KpFJfPLlb6aPGHWpXL8iA=";
          };
        });
      in
      buildNpmPackage {
        pname = "${finalAttrs.pname}-web";
        version = finalAttrs.version;

        src = finalAttrs.src;
        sourceRoot = "${finalAttrs.src.name}/warpgate-web";

        patches = [ ./web-ui-package-json.patch ];

        npmDepsHash = "sha256-hzLQg12q4YhITIohSXSZgmdw014HyzSCHKxrf2BkNrY=";

        nativeBuildInputs = [ openapi-generator-cli' ];

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
    version = "0.14.1";

    env.SOURCE_DATE_EPOCH = 0; # rust-embed determinism

    src = fetchFromGitHub {
      owner = "warp-tech";
      repo = "warpgate";
      tag = "v${finalAttrs.version}";
      hash = "sha256-jPmIyTtNP+YZzWmRXfnYZVnGaL5C+NOxkzHsEvg1Gv4=";
    };

    cargoHash = "sha256-veGVn8uKLKPN8JmzGU4yRvjh7qDwVMDAvdV5KjE9uVo=";

    patches = [ ./disable-rust-reproducible-build.patch ];

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
