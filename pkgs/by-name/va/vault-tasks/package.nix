{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
let
  version = "0.8.0";
in
rustPlatform.buildRustPackage {
  pname = "vault-tasks";
  inherit version;
  src = fetchFromGitHub {
    owner = "louis-thevenet";
    repo = "vault-tasks";
    rev = "v${version}";
    hash = "sha256-liU2zxBEOH5KMftru2PaIYZHLskm9WLNmUakn300/Xo=";
  };
  cargoHash = "sha256-uKhgi3u7YSKLqG2ROCWs6+p206xghnsQ7nIZw5OtkY4=";

  postInstall = "install -Dm444 desktop/vault-tasks.desktop -t $out/share/applications";

  passthru.updateScript = nix-update-script { };

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
