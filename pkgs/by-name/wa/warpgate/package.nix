{
  lib,
  replaceVars,
  fetchFromGitHub,
  rustPlatform,
  buildNpmPackage,
  openapi-generator-cli,
  nixosTests,
  nix-update-script,
  perl,
  withRDPLegacyTLSBackend ? false,
}:
rustPlatform.buildRustPackage (
  finalAttrs:
  let
    webUi = buildNpmPackage {
      pname = "warpgate-web";
      version = finalAttrs.version;

      src = finalAttrs.src;
      sourceRoot = "${finalAttrs.src.name}/warpgate-web";

      patches = [
        ./web-ui-package-json.patch
      ];

      npmDepsHash = "sha256-x3N5fW7g1wyXvTcLdZBcg1Rv57o2dyqIaEyDiZK0T14=";

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
    version = "0.28.0";

    src = fetchFromGitHub {
      owner = "warp-tech";
      repo = "warpgate";
      tag = "v${finalAttrs.version}";
      hash = "sha256-yRm8c/SZ0SvDsRkJlGNJOMtl2iOqfqxJskceQFp+zkw=";
    };

    cargoHash = "sha256-RPARpBFnQbDKy/uXM150nf0xJqOU0Nbw2b6e0Ch61Uw=";

    patches = [
      (replaceVars ./hardcode-version.patch { inherit (finalAttrs) version; })
    ];

    env = {
      # uses nightly feature: gethostname, once_cell_try
      RUSTC_BOOTSTRAP = true;
      RUSTFLAGS = "--cfg tokio_unstable";
    };

    nativeBuildInputs = lib.optional withRDPLegacyTLSBackend perl;

    buildFeatures = [
      "postgres"
      "mysql"
      "sqlite"
    ]
    ++ lib.optional withRDPLegacyTLSBackend "rdp-openssl-tls";

    preBuild = ''
      rm -rf .cargo/
      ln -rs "${webUi}" warpgate-web/dist
    '';

    # skip check, project included tests require python stuff and docker
    doCheck = false;

    passthru = {
      inherit webUi;
      tests = {
        inherit (nixosTests) warpgate;
      };
      updateScript = nix-update-script {
        extraArgs = [ "--subpackage=webUi" ];
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
