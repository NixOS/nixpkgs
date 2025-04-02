{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "tomlq";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "cryptaliagy";
    repo = "tomlq";
    tag = version;
    hash = "sha256-obOR9q+fE5BnqZIsoL4zauKB+djEn1epqGwSjrI7QqU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-RkzAYVMycQwcewuP8wDbL06YddapyFhm+57CGOICey0=";

  meta = {
    description = "Tool for getting data from TOML files on the command line";
    homepage = "https://github.com/cryptaliagy/tomlq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kinzoku ];
    mainProgram = "tq";
  };
}
