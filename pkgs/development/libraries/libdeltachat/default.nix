{ lib
, stdenv
, fetchFromGitHub
, cargo
, cmake
, deltachat-repl
, openssl
, perl
, pkg-config
, python3
, rustPlatform
, sqlcipher
, sqlite
, fixDarwinDylibNames
, CoreFoundation
, Security
, SystemConfiguration
, libiconv
}:

let
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "email-0.0.21" = "sha256-u4CsK/JqFgq5z3iJGxxGtb7QbSkOAqmOvrmagsqfXIU=";
      "encoded-words-0.2.0" = "sha256-KK9st0hLFh4dsrnLd6D8lC6pRFFs8W+WpZSGMGJcosk=";
      "iroh-0.4.1" = "sha256-oLvka1nV2yQPzlcaq5CXqXRRu7GkbMocV6GoIlxQKlo=";
      "lettre-0.9.2" = "sha256-+hU1cFacyyeC9UGVBpS14BWlJjHy90i/3ynMkKAzclk=";
    };
  };
in stdenv.mkDerivation rec {
  pname = "libdeltachat";
  version = "1.131.1";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-core-rust";
    rev = "v${version}";
    hash = "sha256-JXSZrlekvPVGKR+ritxk3Eru2DhtUN9UBtqUZ7G9/gg=";
  };

  patches = [
    ./no-static-lib.patch
  ];

  cargoDeps = rustPlatform.importCargoLock cargoLock;

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
  ] ++ lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];

  buildInputs = [
    openssl
    sqlcipher
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [
    CoreFoundation
    Security
    SystemConfiguration
    libiconv
  ];

  nativeCheckInputs = with rustPlatform; [
    cargoCheckHook
  ];

  passthru = {
    inherit cargoLock;
    tests = {
      inherit deltachat-repl;
      python = python3.pkgs.deltachat;
    };
  };

  meta = with lib; {
    description = "Delta Chat Rust Core library";
    homepage = "https://github.com/deltachat/deltachat-core-rust/";
    changelog = "https://github.com/deltachat/deltachat-core-rust/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.unix;
  };
}
