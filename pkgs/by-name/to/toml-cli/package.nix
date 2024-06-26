{
  lib,
  fetchCrate,
  rustPlatform,
  testers,
  toml-cli,
}:

rustPlatform.buildRustPackage rec {
  pname = "toml-cli";
  version = "0.2.3";

  src = fetchCrate {
    inherit version;
    pname = "toml-cli";
    hash = "sha256-V/yMk/Zt3yvEx10nzRhY/7GYnQninGg9h63NSaQChSA=";
  };

  cargoHash = "sha256-v+GBn9mmiWcWnxmpH6JRPVz1fOSrsjWoY+l+bdzKtT4=";

  cargoTestFlags = [
    "--bin=toml"
    # # The `CARGO_BIN_EXE_toml` build-time env doesn't appear to be resolving
    # # correctly with buildRustPackage. Only run the unittests instead.
    # "--test=integration"
  ];

  passthru.tests = {
    version = testers.testVersion { package = toml-cli; };
  };

  meta = {
    description = "Simple CLI for editing and querying TOML files";
    homepage = "https://github.com/gnprice/toml-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phlip9 ];
    mainProgram = "toml";
  };
}
