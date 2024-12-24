{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "vault-tasks";
  version = "0.6.1";
  src = fetchFromGitHub {
    owner = "louis-thevenet";
    repo = "vault-tasks";
    rev = "v${version}";
    hash = "sha256-H0cfzjOtVzOEoGmj3u80hj1QlK1QEgbl9vq4otlXKew=";
  };
  cargoHash = "sha256-Iezin3TguweHd9RIyFvNL4IWUtXNJbQH2KXIgaXJHgk=";

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
