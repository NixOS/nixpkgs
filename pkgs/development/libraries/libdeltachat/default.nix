{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
, perl
, pkg-config
, rustPlatform
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "libdeltachat";
  version = "1.56.0";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-core-rust";
    rev = version;
    sha256 = "sha256-ZyVEI6q+GzHLEFH01TxS7NqwT7zqVgg0vduyf/fibB8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "0pb1rcv45xa95ziqap94yy52fy02vh401iqsgi18nm1j6iyyngc8";
  };

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
  ]);

  buildInputs = [
    openssl
    sqlite
  ];

  checkInputs = with rustPlatform; [
    cargoCheckHook
  ];

  meta = with lib; {
    description = "Delta Chat Rust Core library";
    homepage = "https://github.com/deltachat/deltachat-core-rust/";
    changelog = "https://github.com/deltachat/deltachat-core-rust/blob/${version}/CHANGELOG.md";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dotlambda ];
  };
}
