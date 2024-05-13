{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "tinymist";
  # Please update the corresponding vscode extension when updating
  # this derivation.
  version = "0.11.8";

  src = fetchFromGitHub {
    owner = "Myriad-Dreamin";
    repo = "tinymist";
    rev = "v${version}";
    hash = "sha256-1mgtyOXSvovO2f4XSdirzTIcUlbFoT9t/UFa2uW5CpI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-0.11.0" = "sha256-J3oSrxylR00r3Tc4KDmuW6ungQkoYJiI7cZEpbyyNsc=";
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

  meta = with lib; {
    changelog = "https://github.com/Myriad-Dreamin/tinymist/blob/${src.rev}/CHANGELOG.md";
    description = "Tinymist is an integrated language service for Typst";
    homepage = "https://github.com/Myriad-Dreamin/tinymist";
    license = licenses.asl20;
    mainProgram = "tinymist";
    maintainers = with maintainers; [ lampros ];
  };
}
