{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "the-way";
  version = "0.20.3";

  src = fetchFromGitHub {
    owner = "out-of-cheese-error";
    repo = "the-way";
    tag = "v${version}";
    hash = "sha256-zsfk5APxbnssMKud9xGc70N+57LSc+vk6sSb2XzFUyA=";
  };

  cargoHash = "sha256-GBr0z2iJuk86xkgZd2sAz+ISTRfESDt99g6ssxXhzhI=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = !stdenv.hostPlatform.isDarwin;
  useNextest = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/the-way config default tmp.toml
    for shell in bash fish zsh; do
      THE_WAY_CONFIG=tmp.toml $out/bin/the-way complete $shell > the-way.$shell
      installShellCompletion the-way.$shell
    done
  '';

  meta = {
    description = "Terminal code snippets manager";
    mainProgram = "the-way";
    homepage = "https://github.com/out-of-cheese-error/the-way";
    changelog = "https://github.com/out-of-cheese-error/the-way/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      figsoda
      numkem
    ];
  };
}
