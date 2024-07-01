{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
, nix-update-script
, testers
, tinymist
}:

rustPlatform.buildRustPackage rec {
  pname = "tinymist";
  # Please update the corresponding vscode extension when updating
  # this derivation.
  version = "0.11.12";

  src = fetchFromGitHub {
    owner = "Myriad-Dreamin";
    repo = "tinymist";
    rev = "refs/tags/v${version}";
    hash = "sha256-hqTVfEKaAG18JpUZajm0XaoX6kw26aE37T/kfoNNxk8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-0.11.1" = "sha256-VDwyTKrtzmjMhVCp/GnZrgL6P6dLyKlLNA+LhoXBDl0=";
      "typst-syntax-0.7.0" = "sha256-yrtOmlFAKOqAmhCP7n0HQCOQpU3DWyms5foCdUb9QTg=";
      "typstfmt_lib-0.2.7" = "sha256-LBYsTCjZ+U+lgd7Z3H1sBcWwseoHsuepPd66bWgfvhI=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.CoreFoundation
    darwin.apple_sdk_11_0.frameworks.CoreServices
    darwin.apple_sdk_11_0.frameworks.Security
    darwin.apple_sdk_11_0.frameworks.SystemConfiguration
  ];

  checkFlags = [
    "--skip=e2e"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      command = "${meta.mainProgram} -V";
      package = tinymist;
    };
  };

  meta = {
    changelog = "https://github.com/Myriad-Dreamin/tinymist/blob/${src.rev}/CHANGELOG.md";
    description = "Tinymist is an integrated language service for Typst";
    homepage = "https://github.com/Myriad-Dreamin/tinymist";
    license = lib.licenses.asl20;
    mainProgram = "tinymist";
    maintainers = with lib.maintainers; [ lampros ];
  };
}
