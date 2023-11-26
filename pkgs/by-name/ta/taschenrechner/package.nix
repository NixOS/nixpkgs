{ lib
, rustPlatform
, fetchFromGitLab
}:

rustPlatform.buildRustPackage rec {
  pname = "taschenrechner";
  version = "1.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.fem-net.de";
    owner = "mabl";
    repo = "taschenrechner";
    rev = version;
    hash = "sha256-PF9VCdlgA4c4Qw8Ih3JT29/r2e7i162lVAbW1QSOlWo=";
  };

  cargoHash = "sha256-SFgStvpcqEwus1JBs5ZyMHO1UD0oWV7mvS6o4v5gIFc=";

  meta = with lib; {
    description = "A cli-calculator written in Rust";
    homepage = "https://gitlab.fem-net.de/mabl/taschenrechner";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ netali ];
    mainProgram = "taschenrechner";
  };
}
