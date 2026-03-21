{
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  pkg-config,
  python3,
  cmake,
  libmysqlclient,
  libpq,
  openssl,
  makeBinaryWrapper,
  lib,
  nix-update-script,
  nixosTests,
  dbBackend ? "mysql",
}:

let
  pyFxADeps = python3.withPackages (p: [
    p.setuptools # imports pkg_resources
    # remainder taken from requirements.txt
    p.pyfxa
    p.tokenlib
    p.cryptography
  ]);
  # utoipa-swagger-ui downloads Swagger UI assets at build time.
  # Prefetch the archive for sandboxed builds.
  swaggerUi = fetchurl {
    url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v5.17.14.zip";
    hash = "sha256-SBJE0IEgl7Efuu73n3HZQrFxYX+cn5UU5jrL4T5xzNw=";
  };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "syncstorage-rs";
  version = "0.22.2";

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = "syncstorage-rs";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-hEDa9hk00QvMY86zrtTq3+UOmbNehDb7Ya8St9u6IuA=";
  };

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
    python3
  ];

  buildInputs =
    lib.optional (dbBackend == "mysql") libmysqlclient
    ++ lib.optionals (dbBackend == "postgresql") [
      libpq
      openssl
    ];

  buildNoDefaultFeatures = true;
  # The syncserver "postgres" feature only enables syncstorage-db/postgres.
  # tokenserver-db/postgres must be enabled separately so the tokenserver
  # can also connect to PostgreSQL (it dispatches on the URL scheme at runtime).
  buildFeatures =
    let
      cargoFeature = if dbBackend == "postgresql" then "postgres" else dbBackend;
    in
    [
      cargoFeature
      "tokenserver-db/${cargoFeature}"
      "py_verifier"
    ];

  SWAGGER_UI_DOWNLOAD_URL = "file://${swaggerUi}";

  preFixup = ''
    wrapProgram $out/bin/syncserver \
      --prefix PATH : ${lib.makeBinPath [ pyFxADeps ]}
  '';

  cargoHash = "sha256-lTjvRTenmxYAYS5HB32x19DLkdd09jeWOhUbzt7TQ4Y=";

  # almost all tests need a DB to test against
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  passthru.tests = { inherit (nixosTests) firefox-syncserver; };

  meta = {
    description = "Mozilla Sync Storage built with Rust";
    homepage = "https://github.com/mozilla-services/syncstorage-rs";
    changelog = "https://github.com/mozilla-services/syncstorage-rs/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "syncserver";
  };
})
