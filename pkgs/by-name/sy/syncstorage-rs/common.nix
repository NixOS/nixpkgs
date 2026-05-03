{
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  pkg-config,
  python3,
  cmake,
  openssl,
  makeBinaryWrapper,
  lib,
  nix-update-script,
  nixosTests,
  ...
}:

let
  pyFxADeps = python3.withPackages (p: [
    p.setuptools # imports pkg_resources
    # remainder taken from requirements.txt
    p.pyfxa
    p.tokenlib
    p.cryptography
  ]);
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "syncstorage-rs";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = "syncstorage-rs";
    rev = "${finalAttrs.version}";
    hash = "sha256-eo8+6wQQRRjvazE3A7+pJfAtTYKUE3ATTTos/yhqaXI=";
  };

  # set cargoHash in override
  #
  # Has to pull from `finalAttrs` here since overriding using `.overrideAttrs`
  # does not appear to work for `rustPlatform.buildRustPackage` attributes.
  cargoHash = finalAttrs.cargoHash;

  # required by utoipa-swagger-ui rust crate as ZIP file
  swaggerUI = fetchurl {
    url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v5.17.14.zip";
    hash = "sha256-SBJE0IEgl7Efuu73n3HZQrFxYX+cn5UU5jrL4T5xzNw=";
  };

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
    python3
  ];

  buildAndTestSubdir = "syncserver";
  buildNoDefaultFeatures = true;

  # Add database features in override
  #
  # Has to pull from `finalAttrs` here since overriding using `.overrideAttrs`
  # does not appear to work for `rustPlatform.buildRustPackage` attributes.
  buildFeatures = finalAttrs.buildFeatures ++ [
    "py_verifier"
  ];

  # Add database backend dependencies in override
  buildInputs = [
    openssl
  ];

  preFixup = ''
    wrapProgram $out/bin/syncserver \
      --prefix PATH : ${lib.makeBinPath [ pyFxADeps ]}
  '';

  # cause utoipa-swagger-ui crate to use Swagger UI version downloaded by Nix
  SWAGGER_UI_DOWNLOAD_URL = "file:${finalAttrs.swaggerUI}";

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
