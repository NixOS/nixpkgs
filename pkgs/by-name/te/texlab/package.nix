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
<<<<<<< HEAD
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "texlab";
  version = "5.25.1";
=======
rustPlatform.buildRustPackage rec {
  pname = "texlab";
  version = "5.24.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = "texlab";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-hd7fDnZqNEz4Ayop3uPqL4IU6xgGsTjMhGvgF+Trgcw=";
  };

  cargoHash = "sha256-4HFl6bPCHSUhHD5QB8sOK6irUaCAioZgKBm67REEYR8=";
=======
    tag = "v${version}";
    hash = "sha256-gwF4cBlS43u2PfOQBxD7iq2JL9tUo8TPJqR0tWNdW9k=";
  };

  cargoHash = "sha256-9sAurVJSpLNgQvJOG7kSXHIr38MHsw3BhGAaxi9xjUE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  outputs = [ "out" ] ++ lib.optional (!isCross) "man";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional (!isCross) help2man;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  # When we cross compile we cannot run the output executable to
  # generate the man page
  postInstall = lib.optionalString (!isCross) ''
    # TexLab builds man page separately in CI:
<<<<<<< HEAD
    # https://github.com/latex-lsp/texlab/blob/v5.25.0/.github/workflows/publish.yml#L110-L114
=======
    # https://github.com/latex-lsp/texlab/blob/v5.24.0/.github/workflows/publish.yml#L110-L114
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    help2man --no-info "$out/bin/texlab" > texlab.1
    installManPage texlab.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Implementation of the Language Server Protocol for LaTeX";
    homepage = "https://github.com/latex-lsp/texlab";
<<<<<<< HEAD
    changelog = "https://github.com/latex-lsp/texlab/blob/v${finalAttrs.version}/CHANGELOG.md";
=======
    changelog = "https://github.com/latex-lsp/texlab/blob/v${version}/CHANGELOG.md";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      doronbehar
      kira-bruneau
    ];
    platforms = lib.platforms.all;
    mainProgram = "texlab";
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
