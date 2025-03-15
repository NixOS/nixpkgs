{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "tlafmt";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "domodwyer";
    repo = "tlafmt";
    tag = "v${version}";
    hash = "sha256-jBY7erB2LuKwCkshVHLV5kFVRJ8lkT63z1gt1Tikei4=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-765tp4wUh7G92vaoViufo6Kk2c/w2d1XjZ3aN5UUAv0=";

  meta = {
    description = "Formatter for TLA+ specs";
    homepage = "https://github.com/domodwyer/tlafmt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ciflire ];
    mainProgram = "tlafmt";
  };
}
