{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "tlafmt";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "domodwyer";
    repo = "tlafmt";
    tag = "v${version}";
    hash = "sha256-wZ0irWf9S4abcT1BvODFAQks9E6BO0gr43ibnSAxddo=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-UAYajXmKPg9Ow3iRqcEhT50YP+i4ZKWOHTTrYR1SzhI=";

  meta = {
    description = "Formatter for TLA+ specs";
    homepage = "https://github.com/domodwyer/tlafmt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ciflire ];
    mainProgram = "tlafmt";
  };
}
