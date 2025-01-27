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
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    tag = "v${version}";
    hash = "sha256-3XC5K4OlituoFMPN9yJkYi+tkH6M0KK5jVAGdr/GLd0=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  postPatch = lib.optionalString withFzf ''
    substituteInPlace src/util.rs \
      --replace '"fzf"' '"${fzf}/bin/fzf"'
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-+Vip7MjVV23dZdD8GxmNFrfnsjmucohMDUZE9vbpG5w=";

  postInstall = ''
    installManPage man/man*/*
    installShellCompletion --cmd zoxide \
      --bash contrib/completions/zoxide.bash \
      --fish contrib/completions/zoxide.fish \
      --zsh contrib/completions/_zoxide
  '';

  meta = with lib; {
    description = "Fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    changelog = "https://github.com/ajeetdsouza/zoxide/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [
      ysndr
      cole-h
      SuperSandro2000
    ];
    mainProgram = "zoxide";
  };
}
