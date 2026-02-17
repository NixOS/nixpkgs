{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "taschenrechner";
  version = "2.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.fem-net.de";
    owner = "mabl";
    repo = "taschenrechner";
    rev = finalAttrs.version;
    hash = "sha256-ZkyZpCOSo30XEjfh6bLiTLQs/efSFtwdlpIu9bO5Sdc=";
  };

  cargoHash = "sha256-29gqkJe/8ghAgAeioQ2r+AYgOI6lzMnDut4WF0Q59Xg=";

  meta = {
    description = "Cli-calculator written in Rust";
    homepage = "https://gitlab.fem-net.de/mabl/taschenrechner";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ netali ];
    mainProgram = "taschenrechner";
  };
})
