{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "datafusion-cli";
  version = "15.0.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "arrow-datafusion";
    rev = version;
    sha256 = "sha256-s+gQoczTesJGOpz4W5hBPDdxo4eQnf+D10+V2kx65Io=";
  };
  sourceRoot = "source/datafusion-cli";

  cargoSha256 = "sha256-w+/5Ig+U8y4nwu7QisnZvc3UlZaEU/kovV6birOWndE=";

  buildInputs = lib.optional stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # fails even outside the Nix sandbox
    "--skip=object_storage::tests::s3_region_validation"
  ];

  meta = with lib; {
    description = "cli for Apache Arrow DataFusion";
    homepage = "https://arrow.apache.org/datafusion";
    changelog = "https://github.com/apache/arrow-datafusion/blob/${version}/datafusion/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
