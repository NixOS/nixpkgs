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
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "Myriad-Dreamin";
    repo = "tinymist";
    rev = "v${version}";
    hash = "sha256-zkW7UBdjjrt6OBs96yGPXJJNu3PoDzKu8Ro8flPTRnM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-0.11.0" = "sha256-UzZ0tbC6Dhn178GQDyLl70WTp3h5WdaBCsEKgLisZ2M=";
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

  meta = with lib; {
    description = "Tinymist is an integrated language service for Typst";
    homepage = "https://github.com/Myriad-Dreamin/tinymist";
    license = licenses.asl20;
    maintainers = with maintainers; [ lampros ];
    mainProgram = "tinymist";
  };
}
