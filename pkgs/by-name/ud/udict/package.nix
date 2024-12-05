{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "udict";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "lsmb";
    repo = "udict";
    rev = "v${version}";
    hash = "sha256-vcyzMw2tWil4MULEkf25S6kXzqMG6JXIx6GibxxspkY=";
  };

  cargoHash = "sha256-WI+dz7FKa3kot3gWr/JK/v6Ua/u2ioZ04Jwk8t9r1ls=";

  cargoPatches = [
    ./0001-update-version-in-lock-file.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Urban Dictionary CLI - written in Rust";
    homepage = "https://github.com/lsmb/udict";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "udict";
  };
}
