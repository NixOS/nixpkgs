{
  lib,
  fetchCrate,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "when-cli";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-LWssrLl2HKul24N3bJdf2ePqeR4PCROrTiVY5sqzB2M=";
  };

  cargoHash = "sha256-ArrKKcTPfp71ltLh1eeEmanFa7B3nLj+jgj4CzINBY0=";

  meta = {
    description = "Command line tool for converting between timezones";
    homepage = "https://github.com/mitsuhiko/when";
    mainProgram = "when";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ loicreynier ];
  };
}
