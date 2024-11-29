{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "vault-tasks";
  version = "0.5.0";
  src = fetchFromGitHub {
    owner = "louis-thevenet";
    repo = "vault-tasks";
    rev = "v${version}";
    hash = "sha256-Ygc19Up/lWLE7eK6AHYbW/+Ddx6om+1cSJB2bxjcf38=";
  };
  cargoHash = "sha256-MgyKiK+JQsiWMDHQDZ/OTxUvXn2sbZmzqZGzRFkgY4o=";

  postInstall = "install -Dm444 desktop/vault-tasks.desktop -t $out/share/applications";

  meta = {
    description = "TUI Markdown Task Manager";
    longDescription = ''
      vault-tasks is a TUI Markdown task manager.
      It will parse any Markdown file or vault and display the tasks it contains.
    '';
    homepage = "https://github.com/louis-thevenet/vault-tasks";
    license = lib.licenses.mit;
    mainProgram = "vault-tasks";
    maintainers = with lib.maintainers; [ louis-thevenet ];
  };
}
