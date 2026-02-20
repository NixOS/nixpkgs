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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zoxide";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2scJ5/+A3ZSpIdce5GLYqxjc0so9sVsYiXNULmjMzLY=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  postPatch = lib.optionalString withFzf ''
    substituteInPlace src/util.rs \
      --replace '"fzf"' '"${fzf}/bin/fzf"'
  '';

  cargoHash = "sha256-4BXZ5NnwY2izzJFkPkECKvpuyFWfZ2CguybDDk0GDU0=";

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
    changelog = "https://github.com/ajeetdsouza/zoxide/blob/v${finalAttrs.version}/CHANGELOG.md";
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
})
