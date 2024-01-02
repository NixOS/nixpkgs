{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "datafusion-cli";
  version = "32.0.0";

  src = fetchFromGitHub {
    name = "datafusion-cli-source";
    owner = "apache";
    repo = "arrow-datafusion";
    rev = version;
    sha256 = "sha256-QJOv2neEOxLvWoGuS3QyBqGOBi1KJQ8feK6LOrHBL8g=";
  };

  sourceRoot = "${src.name}/datafusion-cli";

  cargoHash = "sha256-NYdxDFUBOBC3nTZB8STdZfOz3Dw0htFCqE0qBRMzQvw=";

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
