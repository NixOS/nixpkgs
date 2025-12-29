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
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "texlab";
  version = "5.25.0";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = "texlab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UI88DQjLRJRPgKX3A+PoLNzgm/9uJeNERTrzh5mnAEk=";
  };

  cargoHash = "sha256-xDLKuAfLyo3V++OKb+anw9oHxehwUxqfnDCuT2GSDWw=";

  outputs = [ "out" ] ++ lib.optional (!isCross) "man";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional (!isCross) help2man;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  # When we cross compile we cannot run the output executable to
  # generate the man page
  postInstall = lib.optionalString (!isCross) ''
    # TexLab builds man page separately in CI:
    # https://github.com/latex-lsp/texlab/blob/v5.25.0/.github/workflows/publish.yml#L110-L114
    help2man --no-info "$out/bin/texlab" > texlab.1
    installManPage texlab.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Implementation of the Language Server Protocol for LaTeX";
    homepage = "https://github.com/latex-lsp/texlab";
    changelog = "https://github.com/latex-lsp/texlab/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      doronbehar
      kira-bruneau
    ];
    platforms = lib.platforms.all;
    mainProgram = "texlab";
  };
})
