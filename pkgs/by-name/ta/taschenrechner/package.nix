{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage rec {
  pname = "taschenrechner";
  version = "2.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.fem-net.de";
    owner = "mabl";
    repo = "taschenrechner";
    rev = version;
    hash = "sha256-ZkyZpCOSo30XEjfh6bLiTLQs/efSFtwdlpIu9bO5Sdc=";
  };

  cargoHash = "sha256-29gqkJe/8ghAgAeioQ2r+AYgOI6lzMnDut4WF0Q59Xg=";

  meta = with lib; {
    description = "Cli-calculator written in Rust";
    homepage = "https://gitlab.fem-net.de/mabl/taschenrechner";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ netali ];
    mainProgram = "taschenrechner";
  };
}
