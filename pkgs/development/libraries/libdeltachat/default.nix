{ lib
, stdenv
, fetchFromGitHub
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
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "libdeltachat";
  version = "1.87.0";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-core-rust";
    rev = version;
    hash = "sha256-iRGLNMGs5WawzcqQb5AQTuD4NCJoBUSHfFUXXvm5+jE=";
  };

  patches = [
    ./no-static-lib.patch
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-bmtm+cvjBIlZVRq/vjHd5Sl4FXJHP3cPp4+bWY5SKus=";
  };

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
  ]) ++ lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];

  buildInputs = [
    openssl
    sqlcipher
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [
    CoreFoundation
    Security
    libiconv
  ];

  checkInputs = with rustPlatform; [
    cargoCheckHook
  ];

  passthru.tests = {
    python = python3.pkgs.deltachat;
  };

  meta = with lib; {
    description = "Delta Chat Rust Core library";
    homepage = "https://github.com/deltachat/deltachat-core-rust/";
    changelog = "https://github.com/deltachat/deltachat-core-rust/blob/${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.unix;
  };
}
