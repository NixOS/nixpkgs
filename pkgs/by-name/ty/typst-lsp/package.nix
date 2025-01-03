{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
  nix-update-script,
  vscode-extensions,
  testers,
  typst-lsp,
}:

rustPlatform.buildRustPackage rec {
  pname = "typst-lsp";
  # Please update the corresponding vscode extension when updating
  # this derivation.
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "nvarner";
    repo = "typst-lsp";
    rev = "refs/tags/v${version}";
    hash = "sha256-OubKtSHw9L4GzVzZY0AVdHY7LzKg/XQIhUfUc2OYAG0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-syntax-0.7.0" = "sha256-yrtOmlFAKOqAmhCP7n0HQCOQpU3DWyms5foCdUb9QTg=";
      "typstfmt_lib-0.2.7" = "sha256-LBYsTCjZ+U+lgd7Z3H1sBcWwseoHsuepPd66bWgfvhI=";
    };
  };

  # In order to make typst-lsp build with rust >= 1.80, we use the patched Cargo.lock from
  # https://github.com/nvarner/typst-lsp/pull/515
  # TODO remove once the PR will have been merged upstream
  postPatch = ''
    rm Cargo.lock
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  checkFlags =
    [
      # requires internet access
      "--skip=workspace::package::external::remote_repo::test::full_download"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # both tests fail on darwin with 'Attempted to create a NULL object.'
      "--skip=workspace::fs::local::test::read"
      "--skip=workspace::package::external::manager::test::local_package"
    ];

  # workspace::package::external::manager::test::local_package tries to access the data directory
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      vscode-extension = vscode-extensions.nvarner.typst-lsp;
      version = testers.testVersion { package = typst-lsp; };
    };
  };

  meta = {
    description = "Brand-new language server for Typst";
    homepage = "https://github.com/nvarner/typst-lsp";
    mainProgram = "typst-lsp";
    changelog = "https://github.com/nvarner/typst-lsp/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      figsoda
      GaetanLepage
    ];
  };
}
