{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "datafusion-cli";
  version = "22.0.0";

  src = fetchFromGitHub {
    name = "datafusion-cli-source";
    owner = "apache";
    repo = "arrow-datafusion";
    rev = version;
    sha256 = "sha256-TWvbtuLmAdYS8otD2TpVlZx2FJS6DF03U2zM28FNsfc=";
  };

  sourceRoot = "datafusion-cli-source/datafusion-cli";

  cargoSha256 = "sha256-muWWVJDKm4rbpCK0SS7Zj6umFoMKGMScEAd2ZyZ5An8=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # fails even outside the Nix sandbox
    "--skip=object_storage::tests::s3_region_validation"
    # broken
    "--skip=exec::tests::create_object_store_table_gcs"
  ];

  meta = with lib; {
    description = "cli for Apache Arrow DataFusion";
    homepage = "https://arrow.apache.org/datafusion";
    changelog = "https://github.com/apache/arrow-datafusion/blob/${version}/datafusion/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
