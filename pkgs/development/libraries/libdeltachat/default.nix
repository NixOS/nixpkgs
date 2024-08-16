{ lib
, stdenv
, fetchFromGitHub
, cargo
, cmake
, deltachat-desktop
, deltachat-repl
, deltachat-rpc-server
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
      "email-0.0.20" = "sha256-rV4Uzqt2Qdrfi5Ti1r+Si1c2iW1kKyWLwOgLkQ5JGGw=";
      "encoded-words-0.2.0" = "sha256-KK9st0hLFh4dsrnLd6D8lC6pRFFs8W+WpZSGMGJcosk=";
      "lettre-0.9.2" = "sha256-+hU1cFacyyeC9UGVBpS14BWlJjHy90i/3ynMkKAzclk=";
    };
  };
in stdenv.mkDerivation rec {
  pname = "libdeltachat";
  version = "1.142.1";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-core-rust";
    rev = "v${version}";
    hash = "sha256-ea0OKQWZareqgE1C8lYem3BKaNmqJgYLItOHdPWqz6M=";
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

  # Sometimes -fmacro-prefix-map= can redirect __FILE__ to non-existent
  # paths. This breaks packages like `python3.pkgs.deltachat`. We embed
  # absolute path to headers by expanding `__FILE__`.
  postInstall = ''
    substituteInPlace $out/include/deltachat.h \
      --replace __FILE__ '"${placeholder "out"}/include/deltachat.h"'
  '';

  passthru = {
    inherit cargoLock;
    tests = {
      inherit deltachat-desktop deltachat-repl deltachat-rpc-server;
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
