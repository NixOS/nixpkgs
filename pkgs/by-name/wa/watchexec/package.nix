{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "watchexec";
    repo = "watchexec";
    rev = "v${version}";
    hash = "sha256-BJRvz3rFLaOCNhOsEo0rSOgB9BCJ2LMB9XEw8RBWXXs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VtSRC4lyjMo2O9dNbVllcDEx08zQWJMQmQ/2bNMup6U=";

  nativeBuildInputs = [ installShellFiles ];

  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework AppKit";

  checkFlags = [
    "--skip=help"
    "--skip=help_short"
  ];

  postPatch = ''
    rm .cargo/config.toml
  '';

  postInstall = ''
    installManPage doc/watchexec.1
    installShellCompletion --zsh --name _watchexec completions/zsh
  '';

  meta = with lib; {
    description = "Executes commands in response to file modifications";
    homepage = "https://watchexec.github.io/";
    license = with licenses; [ asl20 ];
    maintainers = [ maintainers.michalrus ];
    mainProgram = "watchexec";
  };
}
