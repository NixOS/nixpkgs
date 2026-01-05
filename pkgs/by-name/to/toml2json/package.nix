{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "toml2json";
  version = "1.3.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-KzMDJ3WBjr8PNP8+6X8c6/g99375B+MARYIKooqA5jY=";
  };

  cargoHash = "sha256-6HMaKak3YI8kH9Wp1/e4dt276B4QyfyZMve1wl5mucQ=";

  meta = with lib; {
    description = "Very small CLI for converting TOML to JSON";
    mainProgram = "toml2json";
    homepage = "https://github.com/woodruffw/toml2json";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ rvarago ];
  };
}
