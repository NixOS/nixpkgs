{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "tlrc";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tlrc";
    rev = "v${version}";
    hash = "sha256-SPYLQ7o3sbrjy3MmBAB0YoVJI1rSmePbrZY0yb2SnFE=";
  };

  cargoHash = "sha256-i2nSwsQnwhiMhG8QJb0z0zPuNxTLwuO1dgJxI4e4FqY=";

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
