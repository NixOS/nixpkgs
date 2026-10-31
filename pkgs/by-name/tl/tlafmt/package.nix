{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tlafmt";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "domodwyer";
    repo = "tlafmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-79tCH4O7VFqiYloCAGVw7JJ5WvsFnjjKdBNmMPar+sk=";
  };

  cargoHash = "sha256-79eI2POpYr7nUThsWohetEzG17JAxMOVul5soJxYYms=";

  meta = {
    description = "Formatter for TLA+ specs";
    homepage = "https://github.com/domodwyer/tlafmt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ciflire ];
    mainProgram = "tlafmt";
  };
})
