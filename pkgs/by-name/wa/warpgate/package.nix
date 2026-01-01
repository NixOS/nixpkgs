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

<<<<<<< HEAD
      npmDepsHash = "sha256-jgsNF93DkEVgPGzdi192HKoSHPYhdrtog28jZvOLK6E=";
      # Fix peer dependency conflicts with ESLint 9.
      npmFlags = [ "--legacy-peer-deps" ];
=======
      npmDepsHash = "sha256-1zCxKAH2IAKSFdL8Pyd8dJi0i8Y5mgYcWNKVpiQszc0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
    version = "0.18.0";
=======
    version = "0.17.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    src = fetchFromGitHub {
      owner = "warp-tech";
      repo = "warpgate";
      tag = "v${finalAttrs.version}";
<<<<<<< HEAD
      hash = "sha256-GLY/VGEKB6gFNTbBlbhpmqQZ62pk2wd6JwWwy4Tz0FE=";
    };

    cargoHash = "sha256-hwAtj8tTDsYgzuDobMg97wepKKIpohSVClyRiaDd+8w=";

    patches = [
      (replaceVars ./hardcode-version.patch { inherit (finalAttrs) version; })
    ];

    RUSTFLAGS = "--cfg tokio_unstable";

=======
      hash = "sha256-nr0z8c0o5u4Rqs9pFUaxnasRHUhwT3qQe5+JNV+LObg=";
    };

    cargoHash = "sha256-pIr5Z7rp+dYOuKYnlsBdya6MqAdL0U2gUhwXvLfmM34=";

    patches = [
      (replaceVars ./hardcode-version.patch { inherit (finalAttrs) version; })
      ./disable-rust-reproducible-build.patch
    ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    buildFeatures = [
      "postgres"
      "mysql"
      "sqlite"
    ];

<<<<<<< HEAD
    preBuild = ''
      rm -r .cargo/
      ln -rs "${warpgate-web}" warpgate-web/dist
    '';
=======
    preBuild = ''ln -rs "${warpgate-web}" warpgate-web/dist'';
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    # skip check, project included tests require python stuff and docker
    doCheck = false;

    passthru.tests = {
      inherit (nixosTests) warpgate;
    };

    meta = {
      description = "Smart SSH, HTTPS, MySQL and Postgres bastion that requires no additional client-side software";
      homepage = "https://warpgate.null.page";
      license = lib.licenses.asl20;
<<<<<<< HEAD
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
=======
      platforms = lib.platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mainProgram = "warpgate";
      maintainers = with lib.maintainers; [ alemonmk ];
    };
  }
)
