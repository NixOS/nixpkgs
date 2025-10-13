{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "tlrc";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tlrc";
    rev = "v${version}";
    hash = "sha256-Q0vRrCNpbG6LihCi9+uI25PnpFuPfoY2MZmyB/IN/SQ=";
  };

  cargoHash = "sha256-IrRhj3Tv8rLTJki+Wd4Xfmf74OnYInUytMnYuvre7mw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage tldr.1
    installShellCompletion completions/{tldr.bash,_tldr,tldr.fish}
  '';

  meta = {
    description = "Official tldr client written in Rust";
    homepage = "https://github.com/tldr-pages/tlrc";
    changelog = "https://github.com/tldr-pages/tlrc/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "tldr";
    maintainers = with lib.maintainers; [ acuteenvy ];
  };
}
