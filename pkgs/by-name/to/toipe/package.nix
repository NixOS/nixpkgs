{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "toipe";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-L4JemOxpynGYsA8FgHnMv/hrogLSRaaiIzDjxzZDqjM=";
  };

  cargoHash = "sha256-bBkHqcPWE6jkqvUZ28ukUidET9XkRQ9t9bfTpHC5Jyo=";

  meta = {
    description = "Trusty terminal typing tester";
    homepage = "https://github.com/Samyak2/toipe";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      loicreynier
      samyak
    ];
  };
}
