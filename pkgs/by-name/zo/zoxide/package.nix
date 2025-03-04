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
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    tag = "v${version}";
    hash = "sha256-+QZpLMlHOZdbKLFYOUOIRZHvIsbMDdstj9oGzyEGVxk=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  postPatch = lib.optionalString withFzf ''
    substituteInPlace src/util.rs \
      --replace '"fzf"' '"${fzf}/bin/fzf"'
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-uqIL8KTrgWzzzyoPR9gctyh0Rf7WQpTGqXow2/xFvCU=";

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
