{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage rec {
  pname = "taschenrechner";
  version = "1.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.fem-net.de";
    owner = "mabl";
    repo = "taschenrechner";
    rev = version;
    hash = "sha256-ZZVghL0R3p5sE8V9Z0MsmTiCacuE2RXohQQEYJYgp/o=";
  };

  cargoHash = "sha256-/tgfHU4/B7tes2jU8L/MbWIG1sTLg9exWhmuSA6Davk=";

  meta = with lib; {
    description = "Cli-calculator written in Rust";
    homepage = "https://gitlab.fem-net.de/mabl/taschenrechner";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ netali ];
    mainProgram = "taschenrechner";
  };
}
