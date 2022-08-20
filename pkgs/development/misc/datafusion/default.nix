{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
}:
let
  pname = "datafusion-cli";
  version = "unstable-2022-04-08";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  # TODO the crate has been yanked so not the best source
  # the repo is a workspace with a lock inside a subdirectory, making
  # compilation from github source not straightforward
  # re-evaluate strategy on release after 7.0.0
  src = fetchFromGitHub {
    owner = "apache";
    repo = "arrow-datafusion";
    rev = "9cbde6d0e30fd29f59b0a16e309bdb0843cc7c64";
    sha256 = "sha256-XXd9jvWVivOBRS0PVOU9F4RQ6MrS/q78JF4S6Htd67w=";
  };
  sourceRoot = "source/datafusion-cli";

  cargoSha256 = "sha256-Q0SjVofl1+sex15sSU9s7PgKeHG2b0gJPSqz7YZFOVs=";

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "cli for Apache Arrow DataFusion";
    homepage = "https://arrow.apache.org/datafusion";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.unix;
  };
}
