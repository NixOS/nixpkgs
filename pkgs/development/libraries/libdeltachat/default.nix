{ lib
, stdenv
, fetchFromGitHub
, cargo
, cmake
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

stdenv.mkDerivation rec {
  pname = "libdeltachat";
  version = "1.121.0";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-core-rust";
    rev = "v${version}";
    hash = "sha256-QefBchXitDcbn1o7jgmvWdacLT8OP+W/dL32+pYsaEA=";
  };

  patches = [
    ./no-static-lib.patch
  ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "email-0.0.21" = "sha256-Ys47MiEwVZenRNfenT579Rb17ABQ4QizVFTWUq3+bAY=";
      "encoded-words-0.2.0" = "sha256-KK9st0hLFh4dsrnLd6D8lC6pRFFs8W+WpZSGMGJcosk=";
      "lettre-0.9.2" = "sha256-+hU1cFacyyeC9UGVBpS14BWlJjHy90i/3ynMkKAzclk=";
      "quinn-proto-0.9.2" = "sha256-N1gD5vMsBEHO4Fz4ZYEKZA8eE/VywXNXssGcK6hjvpg=";
    };
  };

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

  passthru.tests = {
    python = python3.pkgs.deltachat;
  };

  meta = with lib; {
    description = "Delta Chat Rust Core library";
    homepage = "https://github.com/deltachat/deltachat-core-rust/";
    changelog = "https://github.com/deltachat/deltachat-core-rust/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dotlambda srapenne ];
    platforms = platforms.unix;
  };
}
