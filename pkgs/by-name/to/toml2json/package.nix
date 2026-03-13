{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "toml2json";
  version = "1.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ZqHXtk6bPYm/20DjFhVmrc9+wYAmSEBLxqNgyzPGO2c=";
  };

  cargoHash = "sha256-qdALBNQ2re3JQ6SWYsF/lHDxuCf2yyeXgdT1YQY0z6A=";

  meta = {
    description = "Very small CLI for converting TOML to JSON";
    mainProgram = "toml2json";
    homepage = "https://github.com/woodruffw/toml2json";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ rvarago ];
  };
}
