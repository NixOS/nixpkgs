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

  cargoHash = "sha256-xZ3Ki1HLzF7A1+83GQNTBgRjn802Z9ZAKENKB5CykCc=";

  meta = with lib; {
    description = "Cli-calculator written in Rust";
    homepage = "https://gitlab.fem-net.de/mabl/taschenrechner";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ netali ];
    mainProgram = "taschenrechner";
  };
}
