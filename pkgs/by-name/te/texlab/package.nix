{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  help2man,
  installShellFiles,
  libiconv,
  nix-update-script,
}:

let
  isCross = stdenv.hostPlatform != stdenv.buildPlatform;
in
rustPlatform.buildRustPackage rec {
  pname = "texlab";
  version = "5.24.0";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = "texlab";
    tag = "v${version}";
    hash = "sha256-gwF4cBlS43u2PfOQBxD7iq2JL9tUo8TPJqR0tWNdW9k=";
  };

  cargoHash = "sha256-9sAurVJSpLNgQvJOG7kSXHIr38MHsw3BhGAaxi9xjUE=";

  outputs = [ "out" ] ++ lib.optional (!isCross) "man";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional (!isCross) help2man;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  # When we cross compile we cannot run the output executable to
  # generate the man page
  postInstall = lib.optionalString (!isCross) ''
    # TexLab builds man page separately in CI:
    # https://github.com/latex-lsp/texlab/blob/v5.24.0/.github/workflows/publish.yml#L110-L114
    help2man --no-info "$out/bin/texlab" > texlab.1
    installManPage texlab.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Implementation of the Language Server Protocol for LaTeX";
    homepage = "https://github.com/latex-lsp/texlab";
    changelog = "https://github.com/latex-lsp/texlab/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      doronbehar
      kira-bruneau
    ];
    platforms = lib.platforms.all;
    mainProgram = "texlab";
  };
}
