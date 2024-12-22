{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "vault-tasks";
  version = "0.7.0";
  src = fetchFromGitHub {
    owner = "louis-thevenet";
    repo = "vault-tasks";
    rev = "v${version}";
    hash = "sha256-8UIklKwTJWOc6AG8r2Iwdo19k81qg5Y6ESB3yHet6vM=";
  };
  cargoHash = "sha256-2V+kU0LQNaAN2WbJ7hqzzLEszlXtZp2gXwvZsQBzo7I=";

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
