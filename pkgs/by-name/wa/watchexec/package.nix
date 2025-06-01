{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "watchexec";
    repo = "watchexec";
    rev = "v${version}";
    hash = "sha256-ldxB1/WgOe1uGfKXkMEtGHIlWiKJgnZz6j/7eCOGD8s=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LdjJlf4HPN+kZOQKPNSdbYApGBD4Z6tKV9Y0FFKpAf0=";

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
