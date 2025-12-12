{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  perl,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "teip";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "greymd";
    repo = "teip";
    rev = "v${version}";
    hash = "sha256-Lr4nlAM2mEKwF3HXso/6FQEKoQK43xxLMgOU7j7orYg=";
  };

  cargoHash = "sha256-FFv/Msx6fXRJuRH8hjhBgc7XCg5EKWantNKQHwXpa4o=";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ perl ];

  # tests are locale sensitive
  preCheck = ''
    export LANG=${if stdenv.hostPlatform.isDarwin then "en_US.UTF-8" else "C.UTF-8"}
  '';

  postInstall = ''
    installManPage man/teip.1
    installShellCompletion \
      --bash completion/bash/teip \
      --fish completion/fish/teip.fish \
      --zsh completion/zsh/_teip
  '';

  meta = {
    description = "Tool to bypass a partial range of standard input to any command";
    mainProgram = "teip";
    homepage = "https://github.com/greymd/teip";
    changelog = "https://github.com/greymd/teip/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
