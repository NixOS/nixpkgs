{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "toml2json";
  version = "1.3.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-9q2HtNzsRO0/5gcmxUfWuQlWsfvw/A21WEXZlifCUjY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-IglwVFTKOQFln/LE76+QM4P0J9dDM83jSAF6jGGNLEg=";

  meta = with lib; {
    description = "Very small CLI for converting TOML to JSON";
    mainProgram = "toml2json";
    homepage = "https://github.com/woodruffw/toml2json";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ rvarago ];
  };
}
