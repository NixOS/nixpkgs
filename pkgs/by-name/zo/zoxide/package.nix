{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  withFzf ? true,
  fzf,
  installShellFiles,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "zoxide";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    tag = "v${version}";
    hash = "sha256-8hXoC3vyR08hN8MMojnAO7yIskg4FsEm28GtFfh5liI=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  postPatch = lib.optionalString withFzf ''
    substituteInPlace src/util.rs \
      --replace '"fzf"' '"${fzf}/bin/fzf"'
  '';

  cargoHash = "sha256-Nonid/5Jh0WIQV0G3fpmkW0bql6bvlcNJBMZ+6MTTPQ=";

  postInstall = ''
    installManPage man/man*/*
    installShellCompletion --cmd zoxide \
      --bash contrib/completions/zoxide.bash \
      --fish contrib/completions/zoxide.fish \
      --zsh contrib/completions/_zoxide
  '';

  meta = {
    description = "Fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    changelog = "https://github.com/ajeetdsouza/zoxide/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      ysndr
      cole-h
      SuperSandro2000
      matthiasbeyer
      ryan4yin
    ];
    mainProgram = "zoxide";
  };
}
