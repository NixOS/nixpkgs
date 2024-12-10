{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "datafusion-cli";
  version = "33.0.0";

  src = fetchFromGitHub {
    name = "datafusion-cli-source";
    owner = "apache";
    repo = "arrow-datafusion";
    rev = version;
    sha256 = "sha256-ywyzvk50Fr9TSaCrqd14lSi1PJ9ggA1YQ/X0aFGFk1M=";
  };

  sourceRoot = "${src.name}/datafusion-cli";

  cargoHash = "sha256-0a/O9nNi3JLufQxG+5EgCXtV0y03X7R6UY+f/tVGB90=";

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
    mainProgram = "datafusion-cli";
    homepage = "https://arrow.apache.org/datafusion";
    changelog = "https://github.com/apache/arrow-datafusion/blob/${version}/datafusion/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
